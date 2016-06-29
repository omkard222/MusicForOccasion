class AddColumnTwitterFollowersToProfile < ActiveRecord::Migration
  def change
    add_column :profiles, :twitter_followers, :integer
  end
end
