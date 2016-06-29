class AddColumnOfferDefault < ActiveRecord::Migration
  def change
    add_column :services, :is_default, :boolean , default: false
  end
end
