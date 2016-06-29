class AddColumnEmbedVideo < ActiveRecord::Migration
  def change
    add_column :profiles, :youtube_url, :string
    add_column :profiles, :soundcloud_url, :string
  end
end
