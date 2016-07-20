class CreateProfileHistories < ActiveRecord::Migration
  def change
    create_table :profile_histories do |t|
      t.integer :profile_id
      t.string :old_user_email
      t.string :new_user_email
      t.datetime :migration_date

      t.timestamps null: false
    end
  end
end
