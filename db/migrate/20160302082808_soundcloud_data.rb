class SoundcloudData < ActiveRecord::Migration
  def change
    create_table :soundcloud_data do |t|
      t.references :profile, index: true
      t.string :access_token, null: false
      t.string :refresh_token, null: false
      t.string :client_id, null: false
      t.datetime :token_expires_at
      t.datetime :deleted_at
      t.timestamps null: false
    end
  end
end
