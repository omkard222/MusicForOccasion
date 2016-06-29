class ChangeSpecialPriceDefaultValueForBookingRequests < ActiveRecord::Migration
  def self.up
    change_table :booking_requests do |t|
      t.change :special_price, :decimal, precision: 8, scale: 2, default: 0.00
    end
  end
  def self.down
    change_table :booking_requests do |t|
      t.change :special_price, :decimal, precision: 8, scale: 2
    end
  end
end
