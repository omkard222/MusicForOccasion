class AddBillingAddressAndPhoneNumberToUsers < ActiveRecord::Migration
  def change
    add_column :users, :billing_address, :string
    add_column :users, :phone_number, :integer
  end
end
