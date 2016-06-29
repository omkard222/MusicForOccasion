class MoveReviewsToProfiles < ActiveRecord::Migration
  def change
    add_reference :reviews, :reviewer, index: true, foreign_key: true

    Review.find_each do |review|
      profile_id = get_profile_id review.user_id
      if profile_id
        review.update reviewer_id: profile_id
      else
        review.destroy
      end
    end

    remove_reference :reviews, :user
  end

  private

  def get_profile_id(user_id)
    result = Profile.where(current: true, user_id: user_id).first.try(:id)
    result || Profile.where(user_id: user_id).first.try(:id)
  end
end
