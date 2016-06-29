class RemoveColumnDescriptionFromProfile < ActiveRecord::Migration
  def change
    remove_column :profiles, :description, :text
  end
end
