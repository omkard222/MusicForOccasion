# Controller for new service proposal
class JobsController < ApplicationController
  before_action :authenticate_user!, except: [:show,:job_details]
  before_action :find_job, only: [:edit, :update]
  include ApplicationHelper

  def new
   @job = Job.new
   @select2_form = {
        genre_id: [['', Genre.order(:name).all.map { |g| ["#{g.name}", g.id] }]]
    }
  end

  def create
    @job = current_profile.jobs.new(new_job_params)
    if @job.save
      genres_id = params[:job][:genre_id]
      if genres_id.present?
        genres_id.each do |key, value|
          JobGenre.create(job_id: @job.id, genre_id: key)
        end
      end  
      # BookingStatusMailer.service_creation_notification(
        # current_profile).deliver_later if current_user.notify_create_offer
      flash[:success] = 'Offer has been created successfully.'
      redirect_to jobs_path
    else
      flash[:error] = 'Invalid input, please try again.'
      render 'new'
    end
  end

  def index
    
    if current_user.current_profile.profile_type == "musician"
      
      jobs = Job.all
    else
      jobs = current_profile.jobs.all
    end
    @jobs = jobs.where(deleted_at: nil)
    booking_lists = BookingRequest.booking_list(current_user.current_profile.id).where('date < ? AND status <> ?', Date.today, 'Cancelled').update_all(status: 'Expired')
  end

  def update
    if @job.update(new_job_params)
      genres_id = params[:job][:genre_id]
      if genres_id.present?
        job_genres = @job.job_genres
        # @genres = @job.genres.collect() 
        job_genres.each do |g|
          g.destroy
        end 
        genres_id.each do |key, value|
          JobGenre.create(job_id: @job.id, genre_id: key)
        end
      end  
      flash[:success] = 'Offer has been updated successfully.'
      redirect_to jobs_path
    else
      @job = job
      msg = 'Invalid input, please try again.'
      render 'edit', notice: msg
    end
  end
  
  def job_details
    @job = Job.find(params[:id])
  end 

  def edit
    @job = Job.find(params[:id])
    @select2_form = {
        genre_id: [['', Genre.order(:name).all.map { |g| ["#{g.name}", g.id] }]]
    }
    @selected_keys = @job.genres.collect(&:id)
    #raise @selected_keys.inspect
  end 
  
  def show
    @job = Job.find(params[:id])
    genres = @job.genre_ids
    genres = genres-[""]
    g1 = []
    
    if genres.present?
      genres.each do |g|
        g1.push(Genre.find(g).name)
      end
      @genre_name = g1.join(",") 
    end

  end 

  def destroy
    job = Job.find(params[:id])
    job.deleted_at = Time.now
    if job.save
      flash[:success] = 'Offer has been deleted successfully.'
    else
      flash[:error] = 'Failed to delete an offer.'
    end
    redirect_to jobs_path
  end

  private

  def new_job_params
    params.require(:job)
    .permit(:title, :event_type, :description, :booking_fee, :currency, :country_origin,
            :transportation, :accommodation, :food_and_beverage, :minimum_fb_likes,
            :booking_fee_type, :free_fee_type, :service_type_id,
            :is_sunday, :is_monday, :is_tuesday, :is_wednesday, :is_thursday,
            :is_friday, :is_saturday, :date_from, :date_to, :location,
            genre_ids: [])
  end

  def find_job
    @job = current_profile.jobs.find(params[:id] || params[:job][:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to jobs_path, alert: translate('.access_denied')
  end

end
