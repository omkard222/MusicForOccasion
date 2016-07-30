class AdminMessageMailer < ApplicationMailer
  #default to: 'support@gigbazaar.com'
  #default to: 'gee@gigbazaar.com'
  default to: 'rupinder.enbake@gmail.com'
  def new_partner(name, email, subject, message)
    @name = name
    @email = email
    @subject = subject
    @message = message
    mail(subject: "New Partner: #{name}")
  end

  def contact_us(name, email, subject, message)
    @name = name
    @email = email
    @subject = subject
    @message = message
    mail(subject: "New Contact Message: #{name}")
  end

  def delete_account(name, email, message, deleted_at)
    @name = name
    @email = email
    @message = message
    @deleted_at = deleted_at
    mail(subject: "Account #{name} has been deactivated")
  end

end
