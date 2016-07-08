class AddFbConnectTimeToProfiles < ActiveRecord::Migration
  def change
    add_column :profiles, :fb_connect_time, :datetime
    add_column :profiles, :fb_disconnect_time, :datetime
  end
end
