# Booking Request controller for service owner and requestor
class BookingRequestsController < ApplicationController
  include ApplicationHelper
  before_action :authenticate_user!
  def index
    @booking_list = BookingRequest.booking_list(current_user.current_profile.id)
    @request_list = BookingRequest.request_list(current_user.current_profile.id)
  end

  def booking_request
    booking_lists = BookingRequest.booking_list(current_user.current_profile.id)
    booking_lists.update_expired
    @request_booking_list = booking_lists.select { |booking| booking.status == 'Pending' || booking.status == 'Special Offer' || booking.status == 'Accepted' }
    @request_booking_list_history = booking_lists.select { |booking| booking.status == 'Expired' || booking.status == 'Cancelled' || booking.status == 'Rejected' }
  end

  def my_booking
    request_lists = BookingRequest.request_list(current_user.current_profile.id)
    request_lists.update_expired
    @my_booking_list = request_lists.select { |booking| booking.status == 'Pending' || booking.status == 'Special Offer' || booking.status == 'Accepted' }
    @my_booking_list_history = request_lists.select { |booking| booking.status == 'Expired' || booking.status == 'Cancelled' || booking.status == 'Rejected' }
  end

  def accept_request
    request = update_status('Accepted')
    service_name = request.service.headline
    return unless request.save
    create_message_from_booking_action(request)
    if request.special_price
      BookingStatusMailer.accept_special_offer_booking_request_service_owner_notification(request).deliver_later if request.service_proposer.user.notify_accept_booking
    else
      BookingStatusMailer.accept_booking_request_requestor_notification(request).deliver_later if request.profile.user.notify_accept_booking
    end
    redirect_to :back, notice: "You have accepted the offer: '#{service_name}' successfully."
  end

  def modal_submit
    booking = BookingRequest.find(params[:booking_request_id])
    if booking
      headline = booking.service.headline
      if params[:booking_request_action] == "Accept" && (booking.status == "Pending" || booking.status == "Special Offer")
        if modal_accpet_request(booking)
          flash[:success] = "You have accepted the offer: '"+headline+"' successfully."
        else
          flash[:error] = 'Request is not accepted. Please try again.'
        end
      elsif params[:booking_request_action] == "Reject" && (booking.status == "Pending" || booking.status == "Special Offer")
        if modal_reject_request(booking)
          flash[:success] = "You have rejected the offer: '"+headline+"' successfully."
        else
          flash[:error] = 'Request is not rejected. Please try again.'
        end
      elsif params[:booking_request_action] == "Cancel" && booking.status != "Cancelled"
        if modal_cancel_request(booking)
          flash[:success] = "You have cancelled the offer: '"+headline+"' successfully."
        else
          flash[:error] = 'Request is not cancelled. Please try again.'
        end
      else
        flash[:error] = 'Your '+params[:booking_request_action].downcase+' request has rejected. Please try again.'
      end
    else
      flash[:error] = "Your request has denied" # wrong booking request id
    end
    redirect_to :back
  end

  def reject_request
    booking = update_status('Rejected')
    service_name = booking.service.headline
    return unless booking.save
    create_message_from_booking_action(booking)
    if booking.special_price
      BookingStatusMailer.reject_special_offer_booking_request_service_owner_notification(booking).deliver_later if booking.service_proposer.user.notify_reject_booking
    else
      BookingStatusMailer.reject_booking_request_requestor_notification(booking).deliver_later if booking.profile.user.notify_reject_booking
    end
    redirect_to :back, notice: "You have rejected the offer: '#{service_name}' successfully."
  end

  def cancel_request
    booking = BookingRequest.find(params[:booking_request_id])
    cancel_status = booking.status
    request = update_status('Cancelled')
    service_name = request.service.headline
    @msg = 'Request is not cancelled. Please try again.'
    return unless request.save
    create_message_from_booking_action(request)
    if cancel_status == "Pending"
      BookingStatusMailer.cancel_booking_request_service_owner_notification(request).deliver_later if request.service_proposer.user.notify_cancel_booking
    elsif cancel_status == "Special Offer"
      BookingStatusMailer.cancel_special_offer_booking_request_service_owner_notification(request).deliver_later if request.profile.user.notify_cancel_booking
    end
    @msg = "You have cancelled the offer: '#{service_name}' successfully."
    redirect_to :back, notice: @msg
  end

  def cancel_booking
    booking = update_status('Cancelled')
    service_name = booking.service.headline
    @msg = 'Request is not cancelled. Please try again.'
    return unless booking.save
    create_message_from_booking_action(booking)
    send_email_cancel_confirmed =  booking.updated_by_id != booking.profile.user_id ? booking.profile.user.notify_cancel_confirmed_booking : booking.service_proposer.user.notify_cancel_confirmed_booking
    BookingStatusMailer.cancel_confirmed_booking_request_requestor_notification(booking).deliver_later if send_email_cancel_confirmed
    @msg = "You have cancelled the offer: '#{service_name}' successfully."
    redirect_to :back, notice: @msg
  end

  def create
    new_request = current_user.current_profile.booking_requests.new(booking_request_params)
    new_request.status = 'Pending'
    send_inquiry = params[:booking_request][:confirmed_price]!='' ? params[:booking_request][:confirmed_price].to_i : false
    update_confirmed_price_and_service_proposer(new_request,send_inquiry)
    if new_request.service.currency.present?
      new_request.currency = new_request.service.currency
    else
      new_request.currency = session[:preferred_currency]
    end   
    if params[:booking_request][:confirmed_price].present?
      new_request.confirmed_price = params[:booking_request][:confirmed_price].to_i
    else
      new_request.confirmed_price = new_request.service.booking_fee
    end
    if new_request.save
      create_message_from_booking_action(new_request)
      recipient = new_request.service.profile
      current_admin_or_profile.send_message( 
      recipient,          
      new_request.message,
      "Message from #{ username }")
      BookingStatusMailer.new_booking_request_service_owner_notification(new_request).deliver_later if new_request.service_proposer.user.notify_create_booking
      redirect_to list_my_booking_path, notice: 'Booking request is created successfully.'
    else
      flash[:error] = new_request.errors.full_messages.to_sentence
      redirect_to :back
    end
  end

  def create_book_request
    #raise params.inspect
    @job = Job.find(params[:booking_request][:job_id])
    #raise @job.profile.inspect
    new_request = current_user.current_profile.booking_requests.new()
    new_request.status = 'Pending'
    new_request.currency = params[:booking_request][:currency]
    
    new_request.confirmed_price = params[:booking_request][:confirmed_price]
    #new_request.message = params[:booking_request][:message]
    
    new_request.job_id = params[:booking_request][:job_id] 
    new_request.event_location = "delhi"
    new_request.date = Date.today + 2.days
    new_request.service_proposer = @job.profile
    new_request.updated_by = current_user
    if new_request.save!
      create_message_from_job(new_request, @job)
      recipient = @job.profile
      current_admin_or_profile.send_message( 
      recipient,          
      new_request.message,
      "Message from #{ username }")
      #BookingStatusMailer.new_booking_request_service_owner_notification(new_request).deliver_later if new_request.service_proposer.user.notify_create_booking
      redirect_to jobs_path, notice: 'Booking request is created successfully.'
    else
      flash[:error] = new_request.errors.full_messages.to_sentence
      redirect_to :back
    end

  end 

  def update_status(status)
    request = BookingRequest.find(params[:booking_request_id])
    request.status = status
    request.updated_by = current_user
    request
  end

  def update_confirmed_price_and_service_proposer(request,send_inquiry)
    @request = request
    special_price = @request.special_price
    price = @request.service.booking_fee
    if @request.special_offer?
      @request.confirmed_price = special_price
    else
      @request.confirmed_price = send_inquiry ? send_inquiry : price
    end
    @request.service_proposer = @request.service.profile
    @request.updated_by = current_user
  end

  def special_offer
    booking = BookingRequest.find(params[:booking_request][:id])
    if booking.update_attributes(special_offer_params)
      create_message_from_booking_action(booking)
      recipient = booking.profile
        current_admin_or_profile.send_message(
          recipient,
          booking.message,
          "Message from #{ username }")
      BookingStatusMailer.special_offer_booking_request_requestor_notification(booking).deliver_later if recipient.user.notify_create_special_offer
      @msg = 'Special offer has been sent successfully.'
    else
      @msg = 'Please check for the date and try again.'
    end
    redirect_to :back, notice: @msg
  end

  def show
    booking_request = BookingRequest.find(params[:id])
    if booking_request.special_price != 0.0
      booking_price = convert_to_preferred_currency(booking_request.currency, booking_request.special_price)
    else
      booking_price = convert_to_preferred_currency(booking_request.currency, booking_request.confirmed_price ? booking_request.confirmed_price : false)
    end
    if booking_request.service_id.present?
      data = {  id:         booking_request.id,
                profile_id: booking_request.profile_id,
                price:      booking_price,
                currency:   booking_request.currency,
                service_id: booking_request.service_id,
                headline:   booking_request.service.headline,
                status:     booking_request.status,
                full_date:  DateTime.parse(booking_request.date.to_s).strftime("%d %B %Y, %I:%M %P"),
                short_date: DateTime.parse(booking_request.date.to_s).strftime("%d/%m/%Y %H:%M"),
                location:   booking_request.event_location,
                message:    booking_request.message,
                requestor:  booking_request.updated_by_id,
                user_type:  current_user.profiles.first.profile_type
              }
    else
      data = {  id:         booking_request.id,
                profile_id: booking_request.profile_id,
                price:      booking_price,
                currency:   booking_request.currency,
                job_id: booking_request.job_id,
                headline:   booking_request.job.title,
                status:     booking_request.status,
                full_date:  DateTime.parse(booking_request.date.to_s).strftime("%d %B %Y, %I:%M %P"),
                short_date: DateTime.parse(booking_request.date.to_s).strftime("%d/%m/%Y %H:%M"),
                location:   booking_request.event_location,
                message:    booking_request.message,
                requestor:  booking_request.updated_by_id,
                user_type:  current_user.profiles.first.profile_type
              } 
    end           
    render json: data
  end

  private

  def create_message_from_booking_action(request)
    # is_special_offer = request.special_offer?
    is_special_offer = request.special_price.present? && request.special_price > 0.0
    action = request.status
    if action == 'Pending' || action == 'Special Offer'
      action = 'Created'
    end

    MailboxerConversation.transaction do
      if is_special_offer
        sub = "Special offer has been "+ action
      else
        sub = "Booking request has been "+ action
      end
      conversation = MailboxerConversation.new(subject: sub)
      if conversation.save!
        if is_special_offer
          body_msg = I18n.t("#{action}_booking_request_special_offer",
                   headline: "<a class='booking_request' booking_id='#{request.id}' href='/booking_request/#{request.id}'> #{request.service.headline} </a>",
                   currency: request.currency,
                   price: request.special_price)
        else
      
          if request.service.booking_fee
            body_msg = I18n.t("#{action}_booking_request",
                     headline: "<a class='booking_request' booking_id='#{request.id}' href='/booking_request/#{request.id}'> #{request.service.headline} </a>",
                     currency: preferred_currency_session.upcase,
                     price: convert_to_preferred_currency(request.currency, request.service.booking_fee))
          else
            body_msg = I18n.t("#{action}_booking_request",
                     headline: "<a class='booking_request' booking_id='#{request.id}' href='/booking_request/#{request.id}'> #{request.service.headline} </a>",
                     currency: request.currency,
                     price: request.confirmed_price)


          end
        end
        MailboxerNotification.transaction do
          notice = MailboxerNotification.new(body: body_msg, subject: conversation.subject, notified_object_id: request.id,
                                            sender_id: current_user.current_profile.id, sender_type: "Profile", conversation_id: conversation.id)
          notice.type = "Mailboxer::Message"
          if notice.save!
            MailboxerReceipt.transaction do
              requestor = MailboxerReceipt.new(receiver_type: "Profile", notification_id: notice.id, mailbox_type: "sentbox")
              receiver = MailboxerReceipt.new(receiver_type: "Profile", notification_id: notice.id, mailbox_type: "inbox")
              requestor.receiver_id = current_user.current_profile.id
              receiver.receiver_id = (current_user.current_profile.id != request.profile_id) ? request.profile_id : request.service.profile_id
              requestor.created_at = Time.now + 5.seconds
              requestor.updated_at = Time.now + 5.seconds
              receiver.created_at = Time.now + 5.seconds
              receiver.updated_at = Time.now + 5.seconds
              requestor.save! && receiver.save!
            end
          end
        end
      end
    end
  end


  def create_message_from_job(request, job)
    @job = job
    is_special_offer = request.special_offer?
    is_special_offer = request.special_price.present? && request.special_price > 0.0
    action = request.status
    if action == 'Pending' || action == 'Special Offer'
      action = 'Created'
    end

    MailboxerConversation.transaction do
      if is_special_offer
        sub = "Special offer has been "+ action
      else
        sub = "Booking request has been "+ action
      end
      conversation = MailboxerConversation.new(subject: sub)
      if conversation.save!
        if is_special_offer
          body_msg = I18n.t("#{action}_booking_request_special_offer",
                   headline: "<a class='booking_request' booking_id='#{request.id}' href='/booking_request/#{request.id}'> #{@job.title} </a>",
                   currency: request.currency,
                   price: request.special_price)
        else
      
          if @job.booking_fee
            body_msg = I18n.t("#{action}_booking_request",
                     headline: "<a class='booking_request' booking_id='#{request.id}' href='/booking_request/#{request.id}'> #{@job.title} </a>",
                     currency: preferred_currency_session.upcase,
                     price: convert_to_preferred_currency(request.currency, request.job.booking_fee))
          else
            body_msg = I18n.t("#{action}_booking_request",
                     headline: "<a class='booking_request' booking_id='#{request.id}' href='/booking_request/#{request.id}'> #{@job.title} </a>",
                     currency: request.currency,
                     price: request.confirmed_price)


          end
        end
        #raise request.inspect
        MailboxerNotification.transaction do
          notice = MailboxerNotification.new(body: body_msg, subject: conversation.subject, notified_object_id: request.id,
                                            sender_id: current_user.current_profile.id, sender_type: "Profile", conversation_id: conversation.id)
          notice.type = "Mailboxer::Message"
          if notice.save!
            MailboxerReceipt.transaction do
              requestor = MailboxerReceipt.new(receiver_type: "Profile", notification_id: notice.id, mailbox_type: "sentbox")
              receiver = MailboxerReceipt.new(receiver_type: "Profile", notification_id: notice.id, mailbox_type: "inbox")
              requestor.receiver_id = current_user.current_profile.id
              receiver.receiver_id = (current_user.current_profile.id != request.profile_id) ? request.profile_id : @job.profile_id
              requestor.created_at = Time.now + 5.seconds
              requestor.updated_at = Time.now + 5.seconds
              receiver.created_at = Time.now + 5.seconds
              receiver.updated_at = Time.now + 5.seconds
              requestor.save! && receiver.save!
            end
          end
        end
      end
    end
  end

  def modal_accpet_request(request)
    request = update_status('Accepted')
    can_save = request.save
    if can_save
      create_message_from_booking_action(request)
      if request.special_price
        BookingStatusMailer.accept_special_offer_booking_request_service_owner_notification(request).deliver_later if request.service_proposer.user.notify_accept_booking
      else
        BookingStatusMailer.accept_booking_request_requestor_notification(request).deliver_later if request.profile.user.notify_accept_booking
      end
    end
    return can_save
  end

  def modal_reject_request(request)
    request = update_status('Rejected')
    can_save = request.save
    if can_save
      create_message_from_booking_action(request)
      if request.special_price
        BookingStatusMailer.reject_special_offer_booking_request_service_owner_notification(request).deliver_later if request.service_proposer.user.notify_reject_booking
      else
        BookingStatusMailer.reject_booking_request_requestor_notification(request).deliver_later if request.profile.user.notify_reject_booking
      end
    end
    return can_save
  end

  def modal_cancel_request(request)
    cancel_status = request.status
    request = update_status('Cancelled')
    can_save = request.save
    if can_save
      create_message_from_booking_action(request)
      if cancel_status == "Pending"
        BookingStatusMailer.cancel_booking_request_service_owner_notification(request).deliver_later if request.service_proposer.user.notify_cancel_booking
      elsif cancel_status == "Special Offer"
        BookingStatusMailer.cancel_special_offer_booking_request_service_owner_notification(request).deliver_later if request.profile.user.notify_cancel_booking
      elsif cancel_status == 'Accepted'
        send_email_cancel_confirmed =  request.updated_by_id != request.profile.user_id ? request.profile.user.notify_cancel_confirmed_booking : request.service_proposer.user.notify_cancel_confirmed_booking
        BookingStatusMailer.cancel_confirmed_booking_request_requestor_notification(request).deliver_later if send_email_cancel_confirmed
      end
    end
    return can_save
  end

  def booking_request_params
    booking_params = params.require(:booking_request).permit(:date,:event_location,:offer_price,:message)
    booking_params['service_id'] = params[:service_id]
    booking_params
  end

  def special_offer_params
    special_params = params.require(:booking_request).permit(:date,
                                                             :special_price,
                                                             :currency,
                                                             :message)

    special_params['confirmed_price'] = special_params['special_price']
    special_params['status'] = 'Special Offer'
    special_params['updated_by'] = current_user
    special_params
  end
end
