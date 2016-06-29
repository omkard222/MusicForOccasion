class UpdateSpecialOffer < ActiveRecord::Migration
  def change
    change_table :booking_requests do |t|
      t.change :special_price, :decimal, precision: 11, scale: 2
    end
  end
end
