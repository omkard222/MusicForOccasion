class AddMinutesCountToService < ActiveRecord::Migration
  def change
    add_column :services, :minutes_count, :integer
  end
end
