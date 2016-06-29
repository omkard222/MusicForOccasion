# Mailer that handle miscellaneous email
class BookingStatusMailer < Mailboxer::NotificationMailer
  include ApplicationHelper
  layout 'booking_status_mailer'

  def service_creation_notification(profile)
    @profile = profile
    
    @recipient_name = @profile.display_name

    mail(to: @profile.email, subject: 'New service is online')
  end

  def send_email(notification, _receiver)
    @notification = notification
    assign_variables_for_notification(@notification.notified_object)
    send_booking_status_notification(@notification.subject, @notification.body)
    actor = @notification.body
    update_notification(actor, @body)
  end

#create
  def new_booking_request_service_owner_notification(booking)
    @service = booking.service
    @service_owner = booking.service_proposer
    
    @recipient_name = @service_owner.display_name
    @from_profile = booking.profile

    mail(to: "#{@service_owner.display_name} <#{@service_owner.email}>",
        subject: 'You have received a new booking request',
        from: "#{@from_profile.display_name} <noreply@gigbazaar.com>")
  end
#accpet
  def accept_booking_request_requestor_notification(booking)
    @requestor = booking.profile
    @service = booking.service

    @recipient_name = @requestor.display_name
    @from_profile = @service.profile

    mail(to: "#{@requestor.display_name} <#{@requestor.email}>",
        subject: 'Your new booking request has been accepted',
        from: "#{@from_profile.display_name} <noreply@gigbazaar.com>")
  end
#cancel
  def cancel_booking_request_service_owner_notification(booking)
    @service = booking.service
    @service_owner = booking.service_proposer

    @recipient_name = @service_owner.display_name
    @from_profile = booking.profile

    mail(to: "#{@service_owner.display_name} <#{@service_owner.email}>",
        subject: 'Your new booking request has been cancelled',
        from: "#{@from_profile.display_name} <noreply@gigbazaar.com>")
  end
#reject
  def reject_booking_request_requestor_notification(booking)
    @requestor = booking.profile
    @service = booking.service

    @recipient_name = @requestor.display_name
    @from_profile = @service.profile

    mail(to: "#{@requestor.display_name} <#{@requestor.email}>",
        subject: 'Your booking request has been rejected',
        from: "#{@from_profile.display_name} <noreply@gigbazaar.com>")
  end
#create special offer
  def special_offer_booking_request_requestor_notification(booking)
    @requestor = booking.profile
    @service = booking.service
    @booking_request = booking

    @recipient_name = @requestor.display_name
    @from_profile = @service.profile

    mail(to: "#{@requestor.display_name} <#{@requestor.email}>",
        subject: 'You have received a special offer',
        from: "#{@from_profile.display_name} <noreply@gigbazaar.com>")
  end
#accept special offer
  def accept_special_offer_booking_request_service_owner_notification(booking)
    @service = booking.service
    @service_owner = booking.service_proposer
    @booking_request = booking

    @recipient_name = @service_owner.display_name
    @from_profile = @service.profile

    mail(to: "#{@service_owner.display_name} <#{@service_owner.email}>",
        subject: 'Your special offer has been accepted',
        from: "#{@from_profile.display_name} <noreply@gigbazaar.com>")
  end
#reject special offer
  def reject_special_offer_booking_request_service_owner_notification(booking)
    @service = booking.service
    @service_owner = booking.service_proposer
    @booking_request = booking

    @recipient_name = @service_owner.display_name
    @from_profile = @service.profile

    mail(to: "#{@service_owner.display_name} <#{@service_owner.email}>",
        subject: 'Your special offer has been rejected',
        from: "#{@from_profile.display_name} <noreply@gigbazaar.com>")
  end
#cancel special offer
  def cancel_special_offer_booking_request_service_owner_notification(booking)
    @service = booking.service
    @service_owner = booking.service_proposer
    @booking_request = booking

    @recipient_name = booking.profile.display_name
    @from_profile = @service_owner

    mail(to: "#{booking.profile.display_name} <#{booking.profile.email}>",
        subject: 'Your special offer has been cancelled',
        from: "#{@from_profile.display_name} <#{@service_owner.email}>")
  end
#cancel confirmed
  def cancel_confirmed_booking_request_requestor_notification(booking)
    @service = booking.service
    if booking.updated_by_id == booking.profile.user_id
      sent_to = booking.service_proposer
      sent_from = booking.profile
    else
      sent_to = booking.profile
      sent_from = booking.service_proposer
    end

    @recipient_name = sent_to.display_name
    @from_profile = sent_from

    mail(to: "#{sent_to.display_name} <#{sent_to.email}>",
        subject: 'Your confirmed booking has been cancelled',
        from: "#{@from_profile.display_name} <noreply@gigbazaar.com>")
  end

  private

  def update_notification(actor, body)
    @notification.body = body
    @notification.sender =
      actor.to_s == 'requestor' ? @service_owner : @requestor
    @notification.save
  end

  def send_booking_status_notification(status, actor)
    @recipient = actor.to_s == 'requestor' ? @requestor : @service_owner
    category = "#{status}_booking_request_#{actor}"
    subject = I18n.t "#{category}_mailers_subject"
    @body = I18n.t("#{category}_notification_body",
                   headline: "<a class='booking_request' booking_id='#{@booking_request.id}' href='/booking_request/#{@booking_request.id}'> #{@service.headline} </a>",
                   currency: @currency,
                   price: @price)
    mail(to: @recipient.email, subject: subject,
         template_name: "#{category}_notification")
  end


end
