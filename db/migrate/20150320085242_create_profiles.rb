class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.string :username
      t.text :headline
      t.text :biography
      t.date :birthday

      t.timestamps null: false
    end
  end
end
