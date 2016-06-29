class AddCurrencyToServices < ActiveRecord::Migration
  def change
    add_column :services, :currency, :string
  end
end
