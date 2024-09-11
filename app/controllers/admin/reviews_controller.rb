class Admin::ReviewsController < Admin::BaseController
  before_action :find_review, only: %i(accept reject)
  def index
    @q = Review.ransack(params[:q])
    @pagy, @reviews = pagy(@q.result.includes(:user,
                                              request: [:room, :room_type]))
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
