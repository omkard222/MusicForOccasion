class RemoveColumnNotUse < ActiveRecord::Migration
  def change
    remove_column :profiles, :instrument, :string
    remove_column :profiles, :genres, :text
    remove_column :profiles, :location, :string
    remove_column :profiles, :latitude, :float
    remove_column :profiles, :longitude, :float
    remove_column :profiles, :provider, :string
  end
end
