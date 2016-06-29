class AddPositionPriorityToProfile < ActiveRecord::Migration
  def change
    add_column :profiles, :position_priority, :integer, default: 0
    add_index :profiles, :position_priority
    Profile.find_each { |profile| profile.save(validate: false) }
  end
end
