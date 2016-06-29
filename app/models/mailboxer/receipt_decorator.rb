Mailboxer::Receipt.class_eval do
  def conversation_partner(user)
    if mailbox_type == 'inbox'
      message.sender
    elsif mailbox_type == 'sentbox'
      reject_identical_partner(user)
    end
  end

  def reject_identical_partner(user)
    @user = user
    message.recipients.reject do |conversation_partner|
      conversation_partner.id == @user.id &&
        conversation_partner.class.name == @user.class.name
    end.first
  end

  def booking_notification?
    mailbox_type.nil?
  end

  def related_system_message?(sender)
    booking_notification? && notification.sender == sender
  end
end
