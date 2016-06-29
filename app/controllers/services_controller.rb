# Controller for new service proposal
class ServicesController < ApplicationController
  before_action :authenticate_user!, except: [:show]
  before_action :find_service, only: [:edit, :update]
  include ApplicationHelper

  def new
   @service = Service.new
   @service.service_type_id = 2
  end

  def show
    @service = Service.find(params[:id])
  end

  def create
    @service = current_profile.services.new(new_service_params)
    if @service.save
      BookingStatusMailer.service_creation_notification(
        current_profile).deliver_later if current_user.notify_create_offer
      flash[:success] = 'Offer has been created successfully.'
      redirect_to services_path
    else
      flash[:error] = 'Invalid input, please try again.'
      render 'new'
    end
  end

  def index
    services = current_profile.services.all.order(:headline)
    @services = services.where(deleted_at: nil)
  end

  def update
    if @service.update(new_service_params)
      flash[:success] = 'Offer has been updated successfully.'
      redirect_to services_path
    else
      @service = service
      msg = 'Invalid input, please try again.'
      render 'edit', notice: msg
    end
  end

  def delete
    service = Service.find(params[:id])
    booking = BookingRequest.find_by_service_id(service)
    if (BookingRequest.where(service_id: service,status: ['Pending','Special Offer','Accepted'])).reject{ |br| br.date < Date.today}.count == 0
      if service.is_default
        flash[:error] = "Sorry, you can't remove default offer."
      else
        service.deleted_at = Time.now
        if service.save
          flash[:success] = 'Offer has been deleted successfully.'
        else
          flash[:error] = 'Failed to delete an offer.'
        end
      end
    else
      flash[:error] = 'Sorry, you cannot delete this offer because it has ongoing activities. <a href="/booking_request">Manage my bookings</a>.'
    end
    redirect_to services_path
  end

  private

  def service_params
    params.require(:service).permit(:headline,
                                    :description,
                                    :booking_fee,
                                    :currency)
  end

  def new_service_params
    params.require(:service)
    .permit(:headline, :description, :booking_fee, :currency, :service_type_id,
            :is_sunday, :is_monday, :is_tuesday, :is_wednesday, :is_thursday,
            :is_friday, :is_saturday, :date_from, :date_to, :food_and_beverage,
            :booking_fee_type, :free_fee_type, :accommodation, :fee_time_type,
            :minutes_count, :min_num_people)
  end

  def find_service
    @service = current_profile.services.find(params[:id] || params[:service][:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to services_path, alert: translate('.access_denied')
  end

end
