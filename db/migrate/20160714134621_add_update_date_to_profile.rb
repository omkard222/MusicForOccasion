class AddUpdateDateToProfile < ActiveRecord::Migration
  def change
    add_column :profiles, :update_date, :datetime
  end
end
