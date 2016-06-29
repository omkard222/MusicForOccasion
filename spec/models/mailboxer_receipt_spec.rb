require 'rails_helper'

describe MailboxerReceipt do
  it { should belong_to(:mailboxer_notification).with_foreign_key(:notification_id) }
end