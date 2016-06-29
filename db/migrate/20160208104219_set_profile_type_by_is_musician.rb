class SetProfileTypeByIsMusician < ActiveRecord::Migration
  def change
    Profile.where(profile_type: nil).includes(:user).each do |profile| 
      type = profile.user.is_musician ? 1 : 0
      profile.update profile_type: type
    end
  end
end
