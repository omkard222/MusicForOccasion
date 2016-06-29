class AddColumnSettingCancelConfirmToUser < ActiveRecord::Migration
  def change
    add_column    :users, :notify_cancel_confirmed_booking, :boolean , default: true
  end
end
