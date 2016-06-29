class RemoveWrongMessages < ActiveRecord::Migration
  def change
    MailboxerNotification.joins('LEFT OUTER JOIN profiles ON mailboxer_notifications.sender_id = profiles.id AND profiles.deleted_at is NULL')
      .where(profiles: { id: nil }).where(sender_type: 'Profile').destroy_all
    
    MailboxerNotification.joins("INNER JOIN (SELECT mailboxer_receipts.receiver_id, mailboxer_receipts.id, 
      mailboxer_receipts.notification_id FROM mailboxer_receipts LEFT OUTER JOIN profiles ON 
      mailboxer_receipts.receiver_id = profiles.id and profiles.deleted_at IS NULL WHERE profiles.id IS NULL AND 
      mailboxer_receipts.receiver_type = 'Profile') mailboxer_receipts ON 
      mailboxer_notifications.id = mailboxer_receipts.notification_id").destroy_all
  end
end
