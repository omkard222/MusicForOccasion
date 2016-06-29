class AddColumnVisitorUserSignup < ActiveRecord::Migration
  def change
    add_column    :users, :first_name,  :string
    add_column    :users, :last_name,   :string
    add_column    :users, :is_musician, :boolean , default: false
    remove_column :users, :name,        :string
  end
end
