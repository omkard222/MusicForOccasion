class AddLongitudeToJobs < ActiveRecord::Migration
  def change
    add_column :jobs, :longitude, :float
    add_column :jobs, :latitude, :float
  end
end
