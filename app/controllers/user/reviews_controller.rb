class User::ReviewsController < User::BaseController
  def create
    @review = Review.new review_params
    if @review.save
      flash[:success] = t "created"
      redirect_to room_type_path(@review.request.room_type_id)
    else
      flash[:danger] = t "failed"
      redirect_to profile_path
    end
  end

  private
  def review_params
    params.require(:review).permit Review::REVIEWS_PERMITTED
  end
end
