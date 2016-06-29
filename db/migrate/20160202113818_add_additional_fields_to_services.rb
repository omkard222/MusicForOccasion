class AddAdditionalFieldsToServices < ActiveRecord::Migration
  def change
    add_column :services, :booking_fee_type,  :integer, default: 0
    add_column :services, :free_fee_type,     :integer, default: 0
    add_column :services, :food_and_beverage, :text
    add_column :services, :accommodation,     :integer, default: 0
    add_column :services, :fee_time_type,     :integer, default: 0
  end
end
