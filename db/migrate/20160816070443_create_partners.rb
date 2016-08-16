class CreatePartners < ActiveRecord::Migration
  def change
    create_table :partners do |t|
      t.string :name
      t.integer :order
      t.string :partner_picture

      t.timestamps null: false
    end
  end
end
