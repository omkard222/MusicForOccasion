class CreateServiceType < ActiveRecord::Migration
  def change
    create_table :service_types do |t|
      t.string :name
    end
    add_column :services, :service_type_id, :integer, references: :service_type
    add_column :services, :is_sunday, :boolean
    add_column :services, :is_monday, :boolean
    add_column :services, :is_tuesday, :boolean
    add_column :services, :is_wednesday, :boolean
    add_column :services, :is_thursday, :boolean
    add_column :services, :is_friday, :boolean
    add_column :services, :is_saturday, :boolean
    add_column :services, :date_from, :date
    add_column :services, :date_to, :date
  end
end
