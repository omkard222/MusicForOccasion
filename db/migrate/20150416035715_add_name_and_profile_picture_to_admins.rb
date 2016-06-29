class AddNameAndProfilePictureToAdmins < ActiveRecord::Migration
  def change
    add_column :admins, :name, :string
    add_column :admins, :profile_picture, :string
  end
end
