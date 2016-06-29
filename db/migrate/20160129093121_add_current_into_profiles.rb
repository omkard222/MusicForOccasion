class AddCurrentIntoProfiles < ActiveRecord::Migration
  def up
  	add_column :profiles, :current, :boolean
  	add_column :profiles, :profile_type, :integer
    add_column :profiles, :become_current_at, :datetime
  end
  def down
  	remove_column :profiles, :current
  	remove_column :profiles, :profile_type
    remove_column :profiles, :become_current_at
  end
end
