class RemoveIsMusicianFromUser < ActiveRecord::Migration
  def change
    remove_column :users, :is_musician, :string
  end
end
