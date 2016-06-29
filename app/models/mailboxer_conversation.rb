class MailboxerConversation < ActiveRecord::Base
  has_many :mailboxer_notifications, foreign_key: :conversation_id
end
