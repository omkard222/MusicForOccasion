class AddTechRiderToProfiles < ActiveRecord::Migration
  def change
    add_column :profiles, :tech_rider, :string
    add_index :profiles, :tech_rider
  end
end
