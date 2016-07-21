class AddTwitterFriendMailToProfiles < ActiveRecord::Migration
  def change
    add_column :profiles, :twitter_friend_email, :string
    add_column :profiles, :google_friend_email, :string
    add_column :profiles, :scloud_friend_email, :string
  end
end
