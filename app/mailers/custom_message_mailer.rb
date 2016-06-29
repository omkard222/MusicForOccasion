# Customer mailer replacing Mailboxer's default mailer
class CustomMessageMailer <  Mailboxer::MessageMailer
  layout 'mailer'

  def send_email(message, receiver)
    super if receiver.user.notify_receive_message
  end
end
