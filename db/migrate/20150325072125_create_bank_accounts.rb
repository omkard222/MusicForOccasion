class CreateBankAccounts < ActiveRecord::Migration
  def change
    create_table :bank_accounts do |t|
      t.string :name
      t.string :acc_number
      t.string :bank_name
      t.references :user, index: true

      t.timestamps null: false
    end
    add_foreign_key :bank_accounts, :users
  end
end
