class AddDeletedAtToBillingAddresses < ActiveRecord::Migration
  def change
    add_column :billing_addresses, :deleted_at, :datetime
    add_index :billing_addresses, :deleted_at
  end
end
