class AddPreviousAccountMailToProfiles < ActiveRecord::Migration
  def change
    add_column :profiles, :previous_account_mail, :string
    add_column :profiles, :migration_date, :datetime
  end
end
