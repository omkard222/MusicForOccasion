class FixWrongMessages < ActiveRecord::Migration
  def change
    MailboxerNotification.where(sender_type: 'User').find_each do |notification|
      profile_id = get_profile_id notification.sender_id
      notification.update sender_type: 'Profile', sender_id: profile_id
    end
    
    MailboxerReceipt.where(receiver_type: 'User').find_each do |receipt|
      profile_id = get_profile_id receipt.receiver_id
      receipt.update receiver_type: 'Profile', receiver_id: profile_id
    end
  end

  private

  def get_profile_id(user_id)
    result = Profile.where(current: true, user_id: user_id).first.try(:id)
    result || Profile.where(user_id: user_id).first.try(:id)
  end
end
