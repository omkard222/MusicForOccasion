class AddYoutubeFollowersToProfiles < ActiveRecord::Migration
  def change
    add_column :profiles, :youtube_channel_id, :string
    add_column :profiles, :youtube_subscribers, :integer
  end
end
