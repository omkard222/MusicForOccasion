class AddEmailNotificationToUser < ActiveRecord::Migration
  def change
    add_column    :users, :notify_create_offer, :boolean , default: true
    add_column    :users, :notify_create_booking, :boolean , default: true
    add_column    :users, :notify_accept_booking, :boolean , default: true
    add_column    :users, :notify_reject_booking, :boolean , default: true
    add_column    :users, :notify_create_special_offer, :boolean , default: true
    add_column    :users, :notify_cancel_booking, :boolean , default: true
  end
end
