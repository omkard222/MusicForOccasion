require 'rails_helper'

describe MailboxerNotification do
  it { should have_many(:mailboxer_receipts).with_foreign_key(:notification_id) }
  it { should belong_to(:mailboxer_conversation).with_foreign_key(:conversation_id) }
end