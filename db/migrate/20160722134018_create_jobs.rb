class CreateJobs < ActiveRecord::Migration
  def change
    create_table :jobs do |t|
      t.string :title
      t.integer :event_type
      t.text :description
      t.boolean :transportation
      t.boolean :accommodation
      t.boolean :food_and_beverage
      t.integer :minimum_fb_likes
      t.integer :country_of_band
      t.integer :booking_fee_type
      t.integer :free_fee_type
      t.decimal :booking_fee
      t.string :currency
      t.string :genre_ids
      t.datetime :deleted_at
      t.references :profile, index: true

      t.timestamps null: false
    end
    add_index :jobs, :event_type
    add_foreign_key :jobs, :profiles
  end
end
