class AddNameToAuthTwitter < ActiveRecord::Migration
  def change
    add_column :profiles, :twitter_name, :string
  end
end
