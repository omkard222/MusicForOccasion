class AddTwitterConnectTimeToProfiles < ActiveRecord::Migration
  def change
    add_column :profiles, :twitter_connect_time, :datetime
    add_column :profiles, :twitter_disconnect_time, :datetime
  end
end
