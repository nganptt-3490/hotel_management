class Admin::ReviewsController < Admin::BaseController
  before_action :find_review, only: %i(accept reject)
  def index
    reviews = Review.get_review_available_ids params[:room_type],
                                              params[:room_number],
                                              params[:status]
    @pagy, @reviews = pagy reviews, limit: Settings.pagy.items
    @review_start_index = (@pagy.page - 1) * Settings.pagy.items
    @rooms = Room.all
  end

  def accept
    if @review.accepted!
      flash[:success] = t "updated"
    else
      flash[:danger] = t "failed"
    end
    redirect_to admin_reviews_path
  end

  def reject
    if @review.rejected!
      flash[:success] = t "updated"
    else
      flash[:danger] = t "failed"
    end
    redirect_to admin_reviews_path
  end

  private
  def find_review
    @review = Review.find params[:id]

    return if @review

    flash[:warning] = t "record_not_found"
    redirect_to root_path
  end
end
