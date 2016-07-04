class AddSiteLogoToProfiles < ActiveRecord::Migration
  def change
    add_column :profiles, :site_logo, :string
    add_column :profiles, :site_url, :string
  end
end
