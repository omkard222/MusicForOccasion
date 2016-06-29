class AddMinNumPeopleToService < ActiveRecord::Migration
  def change
    add_column :services, :min_num_people, :integer
  end
end
