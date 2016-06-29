class UpdateMaxValuePriceService < ActiveRecord::Migration
  def change
    change_table :services do |t|
      t.change :booking_fee, :decimal, precision: 11, scale: 2
    end
  end
end
