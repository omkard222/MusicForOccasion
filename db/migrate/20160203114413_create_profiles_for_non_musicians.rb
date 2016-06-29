class CreateProfilesForNonMusicians < ActiveRecord::Migration
  def up
    User.find_each do |user|
      user.create_profile unless user.profiles || user.is_musician?
    end
  end

  def down
    User.find_each do |user|
      user.profile.destroy if user.profiles && !user.is_musician?
    end
  end
end
