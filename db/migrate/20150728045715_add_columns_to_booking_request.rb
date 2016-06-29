class AddColumnsToBookingRequest < ActiveRecord::Migration
  def change
    add_column :booking_requests, :offer_price, :float
    add_column :booking_requests, :event_location, :string
    add_column :booking_requests, :message, :text
  end
end
