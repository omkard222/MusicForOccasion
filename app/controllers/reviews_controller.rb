# Controller for review musician profile
class ReviewsController < ApplicationController

  def create
    profile_id = params[:review][:profile_id]
    if Review.create(create_coment)
      flash[:success] = 'Successfully made a review on a profile.'
      redirect_to profile_path(profile_id)
    else
      msg = 'Invalid input, please try again.'
      render 'new', notice: msg
    end
  end

  def delete
    review = Review.find_by_reviewer_id_and_profile_id(params[:id],params[:profile_id])
    review.message = nil
    review.score = nil
    if review.save
      flash[:success] = 'Successfully deleted a comment.'
    else
      flash[:error] = 'Failed to delete a comment.'
    end
    redirect_to profile_path(params[:profile_id])
  end

  def comment_profile
    review = Review.find_by_reviewer_id_and_profile_id(params[:review][:reviewer_id],params[:review][:profile_id])
    if review
      if review.update(comment_it_params)
        flash[:success] = 'Successfully made a review on a profile.'
      else
        flash[:error] = 'Failed to make a review of a profile.'
      end
    else
      review = Review.create(comment_it_params)
      if review
        flash[:success] = 'Successfully made a review on a profile.'
      else
        flash[:error] = 'Failed to make a review of a profile.'
      end
    end
    redirect_to profile_path(params[:review][:profile_id])
  end

  def rate_profile
    review = Review.find_by_reviewer_id_and_profile_id(params[:review][:reviewer_id],params[:review][:profile_id])
    if review
      if review.update(rate_it_params)
        flash[:success] = 'Successfully rated a profile.'
      else
        flash[:error] = 'Failed to rate a profile.'
      end
    else
      review = Review.create(rate_it_params)
      if review
        flash[:success] = 'Successfully rated a profile.'
      else
        flash[:error] = 'Failed to rate a profile.'
      end
    end
    redirect_to profile_path(params[:review][:profile_id])
  end

  private

  def create_coment
    params.require(:review).permit(:message, :reviewer_id, :profile_id, :score)
  end

  def rate_it_params
    params.require(:review).permit(:reviewer_id, :profile_id, :score)
  end

  def comment_it_params
    params.require(:review).permit(:reviewer_id, :profile_id, :message)
  end

end
