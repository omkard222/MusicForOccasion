class CreateServices < ActiveRecord::Migration
  def change
    create_table :services do |t|
      t.string :headline
      t.string :description
      t.decimal :booking_fee, precision: 8, scale: 2
      t.references :user, index: true

      t.timestamps null: false
    end
    add_foreign_key :services, :users
  end
end
