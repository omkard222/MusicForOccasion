class AddColumnSettingReceiveMessageToUser < ActiveRecord::Migration
  def change
    add_column :users, :notify_receive_message, :boolean, default: true
  end
end
