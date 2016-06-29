class AddConfirmedPriceToBookingRequests < ActiveRecord::Migration
  def change
    add_column :booking_requests, :confirmed_price, :decimal
  end
end
