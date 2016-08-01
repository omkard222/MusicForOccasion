class AddCountryOriginToJobs < ActiveRecord::Migration
  def change
    add_column :jobs, :country_origin, :string
  end
end
