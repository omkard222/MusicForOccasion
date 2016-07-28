class AddSubTypeToProfile < ActiveRecord::Migration
  def change
    add_column :profiles, :sub_type, :integer
    add_index :profiles, :sub_type
  end
end
