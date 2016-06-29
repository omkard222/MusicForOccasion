class MoveLocationFromUserToProfile < ActiveRecord::Migration
  def change
    add_column :profiles, :location, :string
    add_column :profiles, :latitude, :float
    add_column :profiles, :longitude, :float

    User.all.find_each do |user|
      user.profiles.update_all(location: user.attributes['location'], 
                               latitude: user.attributes['latitude'], 
                               longitude: user.attributes['longitude'])
    end

    remove_column :users, :location, :string
    remove_column :users, :latitude, :float
    remove_column :users, :longitude, :float
  end
end
