class AddColumnFacebookToProfile < ActiveRecord::Migration
  def change
    add_column :profiles, :facebook_token, :string
    add_column :profiles, :facebook_page_id, :string
    add_column :profiles, :facebook_page_likes, :integer
  end
end
