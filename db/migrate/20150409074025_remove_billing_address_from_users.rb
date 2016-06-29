class RemoveBillingAddressFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :billing_address, :string
  end
end
