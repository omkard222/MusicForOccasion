class AddPriceAndCurrencyToBookingRequests < ActiveRecord::Migration
  def change
    add_column :booking_requests, :special_price, :decimal, precision: 8, scale: 2
    add_column :booking_requests, :currency, :string
  end
end
