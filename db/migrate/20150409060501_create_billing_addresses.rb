class CreateBillingAddresses < ActiveRecord::Migration
  def change
    create_table :billing_addresses do |t|
      t.string :address1
      t.string :address2
      t.integer :post_code
      t.string :city
      t.string :country
      t.references :user, index: true

      t.timestamps null: false
    end
    add_foreign_key :billing_addresses, :users
  end
end
