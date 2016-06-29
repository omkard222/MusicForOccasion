class CreateColumnLocationProfile < ActiveRecord::Migration
  def change
    add_column :profiles, :location, :string
    add_column :profiles, :latitude, :float
    add_column :profiles, :longitude, :float
    add_column :profiles, :provider, :string
  end
end
