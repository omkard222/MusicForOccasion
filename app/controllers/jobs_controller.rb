# Controller for new service proposal
class JobsController < ApplicationController
  before_action :authenticate_user!, except: [:show]
  before_action :find_job, only: [:edit, :update]
  include ApplicationHelper

  def new
   @job = Job.new
  end

  def create
    @job = current_profile.jobs.new(new_job_params)
    if @job.save
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
    jobs = current_profile.jobs.all
    @jobs = jobs.where(deleted_at: nil)
  end

  def update
    if @job.update(new_job_params)
      flash[:success] = 'Offer has been updated successfully.'
      redirect_to jobs_path
    else
      @job = job
      msg = 'Invalid input, please try again.'
      render 'edit', notice: msg
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
    .permit(:title, :event_type, :description, :booking_fee, :currency,
            :transportation, :accommodation, :food_and_beverage, :minimum_fb_likes,
            :booking_fee_type, :free_fee_type, :genre_ids => [])
  end

  def find_job
    @job = current_profile.jobs.find(params[:id] || params[:job][:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to jobs_path, alert: translate('.access_denied')
  end

end
