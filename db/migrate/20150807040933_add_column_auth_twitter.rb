class AddColumnAuthTwitter < ActiveRecord::Migration
  def change
    add_column :profiles, :twitter_token, :string
    add_column :profiles, :twitter_secret, :string
  end
end
