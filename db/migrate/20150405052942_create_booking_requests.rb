class CreateBookingRequests < ActiveRecord::Migration
  def change
    create_table :booking_requests do |t|
      t.datetime :date
      t.references :user, index: true
      t.references :service, index: true

      t.timestamps null: false
    end
    add_foreign_key :booking_requests, :users
    add_foreign_key :booking_requests, :services
  end
end
