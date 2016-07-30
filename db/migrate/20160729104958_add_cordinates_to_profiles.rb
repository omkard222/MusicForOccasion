class AddCordinatesToProfiles < ActiveRecord::Migration
  def change
    add_column :profiles, :crop_x, :integer
    add_column :profiles, :crop_y, :integer
    add_column :profiles, :crop_h, :integer
    add_column :profiles, :crop_w, :integer
  end
end
