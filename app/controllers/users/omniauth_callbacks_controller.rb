module Users
  # controller for facebook authentication
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    def facebook
      if user_signed_in?
        user_profile = current_user.current_profile
        if user_profile
          if user_profile.update(facebook_token: auth.credentials.token)
            get_token_no_error = true
          else
            get_token_no_error = false
          end
        else
          get_token_no_error = false
        end
        if get_token_no_error
          flash[:notice] = 'Connected successfully with Facebook. Select the page you would like to be connected with:'
          redirect_to facebook_page_path
        else
          flash[:error] = 'Failed to connect facebook'
          redirect_to edit_profile_path(current_user.current_profile.id)
        end
      elsif session[:user_fb_idd].present?
        user_profile = Profile.find(session[:user_fb_idd])
        if user_profile
          if user_profile.update(facebook_token: auth.credentials.token)
            get_token_no_error = true
          else
            get_token_no_error = false
          end
        else
          get_token_no_error = false
        end
        if get_token_no_error
          flash[:notice] = 'Connected successfully with Facebook. Select the page you would like to be connected with:'
          redirect_to facebook_friend_page_path
        else
          flash[:error] = 'Failed to connect facebook'
          redirect_to profile_path(user_profile.id)
        end
         
      else
        if existing_account(request.env['omniauth.auth']) || request.env['omniauth.params']['param'] == 'registration'
          @user = User.connections(request.env['omniauth.auth'])
          username = "#{@user.first_name} #{@user.last_name}"
          Profile.create!(profile_type: :registered_user,
                          user_id: @user.id,
                          username: username,
                          stage_name: username) if !session[:is_musician] && !Profile.where(user_id: @user.id).exists?
          if @user.persisted?
            sign_in_and_redirect @user, event: :authentication
            set_flash_message(:notice, :success, kind: @user.provider.capitalize)
          else
            session['devise.facebook_uid'] = request.env['omniauth.auth']
            redirect_to new_user_registration_url
          end
        else
          render 'devise/registrations/choose_account'
        end
      end
    end

    def twitter
      if current_user.present?
        user_profile = Profile.find(current_user.current_profile.id)
        if user_profile
          if user_profile.update(twitter_token: auth.credentials.token, twitter_secret: auth.credentials.secret,
                                 twitter_name: auth.info.nickname, twitter_followers: auth.extra.raw_info.followers_count)
            flash[:notice] = "Connected successfully with Twitter."
          else
            flash[:error] = "Failed to connect twitter"
          end
        end
        redirect_to edit_profile_path(current_user.current_profile.id)
      elsif session[:user_idd].present?
        user_profile = Profile.find(session[:user_idd])
        if user_profile
          if user_profile.invite_friend_email.present?
            ProfileMailer.twitter_connect_success_user(user_profile, user_profile.invite_friend_name,user_profile.twitter_friend_email).deliver_now
            ProfileMailer.twitter_connect_success_profile(user_profile, user_profile.invite_friend_name,user_profile.twitter_friend_email).deliver_now
            user_profile.twitter_connect_time = Time.now
            user_profile.twitter_disconnect_time = nil
            user_profile.save
          end 
          if user_profile.update(twitter_token: auth.credentials.token, twitter_secret: auth.credentials.secret,
                                 twitter_name: auth.info.nickname, twitter_followers: auth.extra.raw_info.followers_count)
            flash[:notice] = "Connected successfully with Twitter."
          else
            flash[:error] = "Failed to connect twitter"
          end
        end
        session[:user_idd]=""
        redirect_to profile_path(user_profile.id)
      end   
    end

    def google_oauth2
      user_profile = current_user.current_profile
      if user_profile
        url = "https://www.googleapis.com/youtube/v3/channels?part=contentDetails&mine=true&access_token="+auth.credentials.token
        url_read = JSON.parse(open(url).read)
        channel_id = url_read['items'][0]['id']
        url_with_channel = "https://www.googleapis.com/youtube/v3/channels?part=statistics&id=#{channel_id}&key=" + ENV["GOOGLE_CLIENT_KEY"]
        url_with_channel_read = JSON.parse(open(url_with_channel).read)
        if !url_with_channel_read['items'].empty?
          user_profile.update(youtube_channel_id: channel_id)
          RecalculateYoutubeSubscribers.youtube_count(user_profile)
          flash[:success] = t('.successfully_connection')
        else
          flash[:error] = t('.without_channel')
        end
      else
        flash[:error] = t('.failed_connection')
      end
      redirect_to edit_profile_path(current_user.current_profile.id)
    end

    def auth
      request.env['omniauth.auth']
    end
  end
end
