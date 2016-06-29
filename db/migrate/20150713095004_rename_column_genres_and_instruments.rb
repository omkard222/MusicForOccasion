class RenameColumnGenresAndInstruments < ActiveRecord::Migration
  def change
    remove_column :instruments, :instrument,  :string
    remove_column :genres,      :genre,       :string
    add_column    :instruments, :name,        :string
    add_column    :genres,      :name,        :string
  end
end
