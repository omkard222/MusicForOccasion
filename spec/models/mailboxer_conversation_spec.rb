require 'rails_helper'

describe MailboxerConversation do
  it { should have_many(:mailboxer_notifications).with_foreign_key(:conversation_id) }
end