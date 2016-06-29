class RemoveUserIdFromServices < ActiveRecord::Migration
  def change
    add_column :services, :profile_id, :integer, index: true

    Service.all.find_each do |service|
      profile = service.user.profiles.where(profile_type: Profile.profile_types[:musician]).first || service.user.profiles.first
      service.update profile_id: profile.id if profile
    end
    
    remove_column :services, :user_id, index: true
  end
end
