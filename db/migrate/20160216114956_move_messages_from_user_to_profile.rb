class MoveMessagesFromUserToProfile < ActiveRecord::Migration
  def up
    User.find_each do |user|
      profile = user.current_profile || user.profiles.first
      next unless profile

      profile_id = profile.id
      MailboxerNotification.where(sender_id: user.id, sender_type: 'User')
        .update_all(sender_id: profile_id, sender_type: 'Profile')
      MailboxerReceipt.where(receiver_id: user.id, receiver_type: 'User')
        .update_all(receiver_id: profile_id, receiver_type: 'Profile')
    end
  end

  def down
    User.find_each do |user|
      MailboxerNotification.where(sender_id: user.profile_ids, sender_type: 'Profile')
        .update_all(sender_id: user.id, sender_type: 'User')
      MailboxerReceipt.where(receiver_id: user.profile_ids, receiver_type: 'Profile')
        .update_all(receiver_id: user.id, receiver_type: 'User')
    end
  end
end
