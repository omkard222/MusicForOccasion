class CreateBankAccountInformationAndPaypalEmail < ActiveRecord::Migration
  
  def up  	
    add_column :profiles, :paypal_account_email, :string
    add_column :profiles, :paypal_account_email_confirmed_at, :datetime
    add_column :profiles, :paypal_account_email_confirmation_status, :integer, default: 0
    add_column :profiles, :paypal_account_email_confirmation_token, :string
    remove_index :bank_accounts, :user_id
    remove_column :bank_accounts, :user_id
    add_column :bank_accounts, :profile_id, :integer
    add_index :bank_accounts, :profile_id
    add_index :bank_accounts, :bank_name
  end

  def down  	
    remove_column :profiles, :paypal_account_email
    remove_column :profiles, :paypal_account_email_confirmed_at
    remove_column :profiles, :paypal_account_email_confirmation_status
    remove_column :profiles, :paypal_account_email_confirmation_token
    remove_index :bank_accounts, :profile_id
    remove_column :bank_accounts, :profile_id
    add_column :bank_accounts, :user_id, :integer
    add_index :bank_accounts, :user_id
    remove_index :bank_accounts, :bank_name
  end

end
