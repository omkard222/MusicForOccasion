class MoveBookingRequestFromUserToProfile < ActiveRecord::Migration
  def up
    add_reference :booking_requests, :profile, index: true, foreign_key: true
    
    BookingRequest.find_each do |br|
      profile_id = get_br_profile_id(br)
      service_proposer_id = get_br_service_proposer_profile_id(br)
      
      br.update(profile_id: profile_id, service_proposer_id: service_proposer_id)
    end

    remove_reference :booking_requests, :user
  end

  def down
    add_reference :booking_requests, :user, index: true, foreign_key: true
    
    BookingRequest.find_each do |br|
      
      user_id = get_user_id_by_profile(br.profile_id)
      service_proposer_id = get_user_id_by_profile(br.service_proposer_id)
      
      br.update(user_id: user_id, service_proposer_id: service_proposer_id)
    end

    remove_reference :booking_requests, :profile
  end

  private

  def get_user_id_by_profile(profile_id)
    Profile.where(id: profile_id).first.try(:user_id)
  end

  def get_br_profile_id(br)
    user  = User.where(id: br.user_id).first
    get_registered_user(user).try(:id) if user
  end

  def get_br_service_proposer_profile_id(br)
    user  = User.where(id: br.service_proposer_id).first
    get_musician(user).try(:id) if user
  end

  def get_musician(user)
    user.current_profile.musician? ? user.current_profile : (user.profiles.musician.first || user.profiles.first)
  end

  def get_registered_user(user)
    user.current_profile.registered_user? ? user.current_profile : (user.profiles.registered_user.first || user.profiles.first)
  end
end
