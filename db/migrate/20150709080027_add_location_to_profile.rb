class AddLocationToProfile < ActiveRecord::Migration
  def change
    add_column :profiles, :stage_name, :string, :unique => true
    add_column :profiles, :category, :string
    add_column :profiles, :instrument, :string
    add_column :profiles, :genres, :text
  end
end
