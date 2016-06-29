class MailboxerNotification < ActiveRecord::Base
  has_many :mailboxer_receipts, dependent: :destroy, foreign_key: :notification_id
  belongs_to :mailboxer_conversation, foreign_key: :conversation_id
end
