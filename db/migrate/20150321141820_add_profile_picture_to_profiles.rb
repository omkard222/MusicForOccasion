class AddProfilePictureToProfiles < ActiveRecord::Migration
  def change
    add_column :profiles, :profile_picture, :string
  end
end
