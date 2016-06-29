class MailboxerReceipt < ActiveRecord::Base
  belongs_to :mailboxer_notification, foreign_key: :notification_id
end
