class AddInviteFriendNameToProfiles < ActiveRecord::Migration
  def change
    add_column :profiles, :invite_friend_name, :string
    add_column :profiles, :invite_friend_email, :string
  end
end
