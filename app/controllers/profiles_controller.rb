#       Controller for managing user's profile
class ProfilesController < ApplicationController
  include ApplicationHelper
  include ServicesHelper
  skip_before_filter :verify_authenticity_token, :only => [:invite_friend, :user_email_change]

  before_action :authenticate_user!, except: [:show, :show_slug, :new, :create, :paypal_confirmation, :invite_friend, :user_email_change]
  before_action :verify_user, only: [:edit, :update, :delete]
  before_action :check_destroy_profile_possibility, only: [:delete]
  before_action :check_soundcloud_datum, only: [:soundcloud, :soundcloud_request]

  def users_profiles_list
    @profiles = current_user.profiles.order(:profile_type).order(:id)
  end

  def new
    @no_menu = true
    @type = params[:type]
    @user = current_user ? current_user : User.find(params[:user])
    @profile = @user.profiles.build
    @pictures = @profile.additional_pictures.all
    @services = @profile.services.all
    select2_form
  end

  def delete_profile
    @profile = current_user.current_profile
    @able_to_destroy_current_profile = current_user.profiles.count > 1
  end

  def choose_profile
    profile = Profile.find(params[:profile_id])
    profile.user.set_current_profile(params[:profile_id])
  rescue
    flash[:error] = t(:internal_server_error)
  ensure
    profile_name = profile.musician? ? profile.stage_name : profile.username
    flash[:success] = "You are signed in as #{profile_name}." unless flash[:error].present?
    redirect_to root_path
  end

  def soundcloud
    return redirect_to root_path, alert: t('.forbidden') if params[:code].nil?
    safe_soundcloud_authorization_block(params[:code])
    redirect_to edit_profile_path(current_profile.id)
  end

  def soundcloud_request
    url = Rails.cache.read('soundcloud_url') || SoundcloudDatum.soundcloud_authorize_url
    redirect_to url
  end

  def soundcloud_disconnect
    profile = Profile.find(current_user.current_profile.id)
    profile.soundcloud_datum.destroy
    flash[:success] = t('.success')
  rescue
    flash[:error] = t('.fail')
  ensure
    redirect_to edit_profile_path(profile.id)
  end

  def destroy
    respond_to do |format|
      format.html do
        profile = Profile.find(params[:id])
        if current_user.profiles.count > 1
          profile.destroy
          if Profile.unscoped.where(id: profile.id).where('deleted_at IS NOT NULL').count > 0
            id = current_user.profiles.first.id
            current_user.set_current_profile(id)
            flash[:success] = t('.successful_profile_deletion', name: profile.stage_name)
            @path  = root_path
          else
            set_unable_to_delete_profile_result(profile)
          end
        else
          set_unable_to_delete_profile_result(profile)
        end
      end
    end
  rescue
    logger.warn '-'*100
    logger.warn 'Error occured during profile deletion'
    logger.warn $!.message
    logger.warn $!.backtrace.join("\n")
    logger.warn '-'*100
    flash[:error] = t(:internal_server_error)
    @path = profile_delete_profile_path(params[:id])
  ensure
    redirect_to @path
  end

  def create
    @no_menu = true
    @profile = Profile.new(create_profile.except(:profile_type))
    @user = current_user ? current_user : User.find(@profile.user_id)
    @profile.profile_type = create_profile[:profile_type].to_i
    if @profile.valid?
      if @profile.save!
        @user.set_current_profile(@profile.id)
        # current_user.set_current_profile(@profile.id)
        if @profile.musician?
          genres_id = params[:profile][:genre_id]
          instruments_id = params[:profile][:instrument_id]
          genres_id.each do |key, value|
            MusicianGenre.create(profile_id: @profile.id, genre_id: key)
          end
          create_default_service
        end
        @profile = @user.current_profile
        @profile.instruments = Instrument.where(id: instruments_id)
        @profile.save
        # profile = current_user.profile
        # instruments_id = params[:profile][:instrument_id]
        # profile.instruments.concat(Instrument.where(id: instruments_id))
        session[:is_musician] = nil
        if current_user
          flash[:success] = t('.success')
          redirect_to profile_path(@profile.id)
        else
          flash[:success] = t('.able_to_login')
          redirect_to new_user_session_path
        end
      else
        select2_form
        flash[:error] = 'Failed to create profile. Please try again.'
        render 'new'
      end
    else
      select2_form
      flash[:error] = 'Stage name has already been taken.'
      render 'new'
    end
  end

  def facebook_page
    user_profile = current_user.current_profile
    url = "https://graph.facebook.com/me/accounts?access_token="+current_user.current_profile.facebook_token.to_s
    #ProfileMailer.facebook_connect_success_user(user_profile, user_profile.username,user_profile.headline).deliver_now
    #ProfileMailer.facebook_connect_success_profile(user_profile, user_profile.username,user_profile.headline).deliver_now
    begin
      fb_info_json = JSON.parse(open(url).read)
      @pages_info = fb_info_json["data"]
    rescue
      user_profile = Profile.find(current_user.current_profile.id)
      user_profile.facebook_token = nil
      user_profile.facebook_page_id = nil
      user_profile.facebook_page_likes = nil
      user_profile.save
      flash[:error] = "Sorry, your connection are exipred. please try to connect facebook agian."
      redirect_to edit_profile_path(current_user.current_profile.id)
    end
  end

  def facebook_page_connect
    profile = current_user.current_profile
    likes = FacebookLikesLoader.get_likes_for profile, params[:profile][:facebook_page_id]

    if profile.update(facebook_page_id_param.merge(facebook_page_likes: likes))
      flash[:notice] = "Connected successfully with Facebook page."
    else
      flash[:error] = "Failed to connect facebook page"
    end
    redirect_to edit_profile_path(current_user.current_profile.id)
  end

  def facebook_disconnect
    user_profile = Profile.find(current_user.current_profile.id)
    if user_profile
      begin
        user_profile.disconnect_facebook!
      rescue
        flash[:error] = "Failed to disconnect facebook"
      end
      flash[:notice] = "Disconnected successfully with your facebook page."
    else
      flash[:error] = "Failed to disconnect facebook"
    end
    redirect_to edit_profile_path(current_user.current_profile.id)
  end

  def twitter_disconnect
    user_profile = Profile.find(current_user.current_profile.id)
    if user_profile
      begin
        user_profile.twitter_token = nil
        user_profile.twitter_secret = nil
        user_profile.twitter_followers = nil
        user_profile.twitter_name = nil
        user_profile.save!
      rescue
        flash[:error] = "Failed to disconnect twitter"
      end
      flash[:notice] = "Disconnected successfully with Tweeter."
    else
      flash[:error] = "Failed to disconnect twitter"
    end
    redirect_to edit_profile_path(current_user.current_profile.id)
  end

  def youtube_disconnect
    user_profile = current_user.current_profile
    if user_profile
      begin
        user_profile.youtube_subscribers = nil
        user_profile.youtube_channel_id = nil
        user_profile.save!
      rescue
        flash[:error] = t('.failed_disconnected')
      end
      flash[:notice] = t('.successfully_disconnected')
    else
      flash[:error] = t('.failed_disconnected')
    end
    redirect_to edit_profile_path(current_user.current_profile.id)
  end

  def show_slug
    @profile = Profile.find_by_slug(params[:slug])
    if @profile
      @twitter_followers = @profile.twitter_followers
      @popularity = @profile.calculate_popularity
      @soundcloud = @profile.get_soundcloud_user_info
      @user = @profile.user
      @pictures = @profile.additional_pictures.all
      services = @profile.services.all
      @services = services.where(deleted_at: nil)
      @instruments = @profile.instruments
      get_review = @profile.collect_reviews
      if @profile.biography && @profile.biography.length > 750
        # @bio_show = @profile.biography[0..1250].squish
        # @bio_hide = @profile.biography[1251..-1].try(:squish)
        # @bio_show = @profile.biography[0..1250].squish
        # @bio_hide = @profile.biography[1251..-1]
        @bio_show = @profile.biography[0..750]
        @bio_hide = @profile.biography[750..-1]
      else
        @bio_show = @profile.biography
        @bio_hide = false
      end
      begin
        review_current_profile = get_review.find_by_reviewer_id(current_profile.id)
        @old_commented = review_current_profile.message  ? review_current_profile.message : ""
        @user_rate = review_current_profile.score ? review_current_profile.score : 0
      rescue
        @user_rate = 0.00
      end
      @reviews_comment = get_review.where.not(message: nil).order(:created_at)
      review_scores = get_review.where(profile_id: @profile.id, deleted_at: nil)
      @rate_count = review_scores.where.not(score: nil).count
      @score_average = review_scores.average(:score).to_f

      render :show
    else
      redirect_to root_url, :flash => { :error => "Musician not found." }
    end
  end

  def show
    profile = Profile.find_by_id(params[:id])
    if profile.nil?
      redirect_to root_url, flash: {error: translate('.not_found')}
    else
      redirect_to profile_slug_url(slug: profile.slug), status: 301
    end
  end

  def edit
    @profile = Profile.find(params[:id])
    @bank_account = @profile.bank_account || @profile.create_bank_account
  end

  def update
    #raise params.inspect
    @profile = Profile.find(params[:id])
    if @profile.update(update_profile)
      respond_to do |format|
        format.json{ render :json=>  {:status => 200, :response=>"ok"} }
        #flash[:success] = translate('.success')
        #redirect_to profile_path
        format.html { redirect_to profile_path, :flash => { :success => translate('.success') }}
      end  
    else
      check_for_error(update_profile)
    end
  end
  
  def paypal_confirmation
    profile = Profile.find(params[:profile_id])
    if profile.paypal_confirmation_sent? && 
      profile.paypal_account_email_confirmation_token == params[:token]
      profile.paypal_confirm
      flash[:success] = t('.success')
    elsif profile.paypal_account_email_confirmation_token != params[:token]
      flash[:error] = t('.wrong_confirmation')
    elsif profile.paypal_confirmed?
      flash[:error] = t('.confirmation_already_sent')
    else      
      flash[:error] = t('.confirmation_reset')
    end
  rescue
    Rollbar.error($!)
    flash[:error] = t('.fail')
  ensure
    redirect_to root_path
  end

  def paypal_confirm
    profile = current_user.current_profile
    profile.send_paypal_confirmation(params[:email])
    flash[:success] = t('.success')
  rescue
    Rollbar.error($!)
    flash[:error] = t('.fail')
  ensure
    redirect_to edit_profile_path(profile.id)    
  end

  def paypal_remove_confirmation
    profile = current_user.current_profile
    profile.remove_confirmation
    flash[:success] = t('.success')
  rescue
    Rollbar.error($!)
    flash[:error] = t('.fail')
  ensure
    redirect_to edit_profile_path(profile.id)
  end

  
  def facebook_one
    respond_to do |format|
      format.html
      format.js
    end
  end

  def facebook_two
    @profile = Profile.find(current_user.current_profile.id)
    
    #raise "bdbdfjbdfj".inspect
    respond_to do |format|
      format.html
      format.js
    end
  end


   def invite_friend
    user_profile = current_user.current_profile
    name = params[:name]
    email = params[:email]
    user_profile.username = params[:name]
    user_profile.headline = params[:email]
    user_profile.save
    #ProfileMailer.invite_mail(user_profile, name, email).deliver_now
    # raise user_profile.inspect
    # respond_to do |format|
    #   format.html
    # end
    redirect_to edit_profile_path(user_profile.id)
  end 

  def user_email_change
    @profile = Profile.find(params[:profile_id])
    @user = User.where(:email => params[:email]).first
    @old_user = User.where(:email => params[:old_email]).first
    old_email = params[:old_email]
    new_email = params[:email]
    if @user.present? && @profile.present? && @old_user.present?
      @profile.update_columns(:user_id => @user.id, :previous_account_mail => old_email, :migration_date => Time.now )
      ProfileMailer.profile_mail_previous(@profile, @old_user, @user).deliver_now
      ProfileMailer.profile_mail_current(@profile, @old_user, @user).deliver_now
    end  
    respond_to do |format|
      format.json{ render :json=>  {:status => 200, :new_email=> new_email, :old_email => old_email, :new_user_id => @user.id, :old_user_id => @old_user.id, :profile_name => @profile.stage_name, :profile_created_at => @profile.created_at.strftime('%d/%m/%y'), :profile_migrated_at => @profile.migration_date.strftime('%d/%m/%y') } }
    end  
  end


  private

  def set_unable_to_delete_profile_result(profile)
    flash[:error] = t('.unable_to_delete_profile')
    @path = profile_delete_profile_path(profile)
  end

  def select2_form
    @select2_form = {
        instrument_id: [['', Instrument.order(:name).all.map { |i| ["#{i.name}", i.id] }]],
        genre_id: [['', Genre.order(:name).all.map { |g| ["#{g.name}", g.id] }]]
    }
  end

  def check_for_error(update_profile)
    if update_profile['location'].blank?
      flash[:error] = 'Please provide valid location'
    else
      image = MiniMagick::Image.open(update_profile['site_logo'].path)
      if image[:width] > 50 && image[:height] > 50
        flash[:error] = 'Image should be of Size 50x50.'
      else
        flash[:error] = 'Stage name has already been taken.'
      end  
    end
    select2_form
    render 'edit'
  end

  def create_profile
    params.require(:profile).permit(:stage_name, :category, :user_id, :profile_type, :location, :username)
  end

  def update_profile
    params[:profile][:instrument_ids] = nil unless params[:profile][:category] == 'Solo'
    params.require(:profile).permit(:stage_name, :category, :user_id, :biography, :profile_picture,
                                    :youtube_url, :soundcloud_url, :location, :username, :tech_rider,:site_logo, :site_url, :remove_tech_rider,:remove_site_logo,
                                    instrument_ids: [],
                                    genre_ids: [],
                                    bank_account_attributes: [:bank_name, :acc_number, :name])
  end

  def facebook_page_id_param
    params.require(:profile).permit(:facebook_page_id,:facebook_page_likes)
  end

  def verify_user
    if params[:id].to_s != current_user.current_profile.id.to_s
      flash[:error] = "Your access has been denied !"
      redirect_to profile_path(current_user.current_profile)
    end
  end

 
  def check_soundcloud_datum
    if current_profile.soundcloud_datum
      flash[:error] = t('profiles.client_already_exists')
      redirect_to edit_profile_path(current_profile.id)
    end
  end

  def create_default_service
    Service.create(headline: 'Live Performance',
                   profile_id: @user.current_profile.id,
                   currency: session[:preferred_currency].to_s,
                   service_type_id: 2,
                   is_monday: true,
                   is_tuesday: true,
                   is_wednesday: true,
                   is_thursday: true,
                   is_friday: true,
                   is_saturday: true,
                   is_sunday: true,
                   is_default: true)
  end

  private

    def safe_soundcloud_authorization_block(callback_code)
      current_profile.process_soundcloud_authorization_response(callback_code)
      flash[:success] = t('.success')
    rescue ActiveRecord::RecordInvalid
      flash[:error] = t('.client_id_error')
    rescue Soundcloud::ResponseError
      if $!.message.include?('invalid_grant')
        logger.warn '-'*100
        logger.warn 'Someone tries to connect his profile with soundcloud account more than one time'
        logger.warn $!.message
        logger.warn '-'*100
      else
        raise $!
      end
    end
end
