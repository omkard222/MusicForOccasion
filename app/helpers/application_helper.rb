# default helper file for rails application
module ApplicationHelper
  require 'slim/smart'
  SUPPORT_EMAIL = 'gee@gigbazaar.com'
  def unread_msg_count
    current_admin_or_profile.mailbox.receipts
        .joins(:message)
        .where(mailbox_type: 'inbox', is_read: false)
        .count
  end

  def unread_msg_count_from_sender(sender_id)
    current_admin_or_profile.mailbox.receipts
        .joins(:message)
        .where(mailbox_type: 'inbox', is_read: false)
        .where("mailboxer_notifications.sender_id = #{sender_id}")
        .count
  end

  def permit_devise_parameters
    devise_parameter_sanitizer.for(:sign_up) do |user|
      user.permit(:email, :password, :password_confirmation,
                  :terms_and_policies,
                  :first_name, :last_name)
    end
    devise_parameter_sanitizer.for(:account_update) do |user|
      user.permit(:email, :password, :password_confirmation, :phone_number)
    end
  end

  def search_session
    session[:search_results]
  end

  def assign_variables_for_notification(booking)
    @booking_request = booking
    @service = @booking_request.service
    @service_owner = @service.user
    @requestor = @booking_request.user
    @currency = @booking_request.currency.upcase
    @price = @booking_request.confirmed_price
  end

  def send_notifications(status, booking)
    assign_variables_for_notification(booking)
    @service_owner.send_system_notification(status, :service_owner, booking)
    @requestor.send_system_notification(status, :requestor, booking)
  end

  def current_model
    admin_signed_in? ? current_admin : current_user
  end

  def current_admin_or_profile
    admin_signed_in? ? current_admin : current_user.current_profile
  end

  def username
    admin_signed_in? ? current_admin.username : current_user.display_name
  end

  def preferred_currency_session
    begin
      unless session[:preferred_currency]
        session[:preferred_currency] = ENV['DEFAULT_CURRENCY']
      end
      session[:preferred_currency].downcase
    rescue
      ENV['DEFAULT_CURRENCY'].try(:downcase) || 'usd'
    end
  end

  def convert_to_preferred_currency(original_currency, amount)
    if amount.present?
      original_currency = original_currency.downcase
      if original_currency == preferred_currency_session || amount.to_i == 0
        amount # no conversion will be ocurring
      else
        conversion_name = "#{original_currency}_to_#{preferred_currency_session}"
        converted_currency = GoogCurrency.send(conversion_name, amount)
        currency_with_margin = converted_currency + margin_of_conversion(
            converted_currency)
        currency_with_margin.round(2)
      end
    end
  end

  def margin_of_conversion(currency)
    @currency = currency
    @currency * (ENV['CURRENCY_CONVERSION_MARGIN_PERCENTAGE'].to_i / 100.0)
  end

  def authenticate_any!
    admin_signed_in? ? authenticate_admin! : authenticate_user!
  end

  def flash_type(name)
    case name
      when "alert", "error"
        "danger"
      when "notice"
        "info"
      when "success"
        "success"
      else
        "info"
    end
  end

  def profile_picture(profile)
    if profile.pic_link_able?
      link_to image_tag(profile.picture, class: 'img-circle img-inbox', title: profile.virtual_name), profile_path(profile)
    else
      image_tag(profile.picture, class: 'img-circle img-inbox', title: profile.virtual_name)
    end
  end

  def current_profile
    current_user.try(:current_profile)
  end

  def support_email_link
    mail_to SUPPORT_EMAIL, SUPPORT_EMAIL,
                           subject: 'Gig Bazaar%20Support',
                           class: 'account',
                           title: "mailto:#{SUPPORT_EMAIL}subject=Gig Bazaar Support"
  end

  def existing_account(auth)
    User.where(email: auth.info.email).exists?
  end

  def forced_sign_out
    reset_session
  end

  def current_translations
    @translations ||= I18n.backend.send(:translations)
    @translations[I18n.locale].with_indifferent_access
  end

  def branch_info
    id = ENV["HEROKU_SLUG_COMMIT"]
    content_tag(:h4) do
      content_tag :span,  ("kodep/booking_core_project:
                  #{link_to id, 'https://github.com/kodep/booking_core_project/commit/' + id,  target: '_blank'}.").html_safe ,
                  class: 'label label-info'
    end
  end
end
