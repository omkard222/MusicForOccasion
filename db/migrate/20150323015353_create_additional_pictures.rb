class CreateAdditionalPictures < ActiveRecord::Migration
  def change
    create_table :additional_pictures do |t|
      t.string :image
      t.references :profile, index: true

      t.timestamps null: false
    end
    add_foreign_key :additional_pictures, :profiles
  end
end
