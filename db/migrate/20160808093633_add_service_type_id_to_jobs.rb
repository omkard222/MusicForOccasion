class AddServiceTypeIdToJobs < ActiveRecord::Migration
  def change
    add_column :jobs, :service_type_id, :integer
    add_column :jobs, :is_sunday, :boolean
    add_column :jobs, :is_monday, :boolean
    add_column :jobs, :is_tuesday, :boolean
    add_column :jobs, :is_wednesday, :boolean
    add_column :jobs, :is_thursday, :boolean
    add_column :jobs, :is_friday, :boolean
    add_column :jobs, :is_saturday, :boolean
    add_column :jobs, :date_from, :date
    add_column :jobs, :date_to, :date 
  end
end
