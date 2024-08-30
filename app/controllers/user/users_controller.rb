class User::UsersController < User::BaseController
  before_action :logged_in_user, only: %i(show)
  before_action :find_request, only: %i(cancel)
  def show
    @pagy, @requests = pagy @current_user.requests.order_by_created_at_desc,
                            limit: Settings.pagy.items5
    @review = Review.new
  end

  def cancel
    if @request.update(deleted_at: Time.current)
      flash[:success] = t "mess.request_cancelled"
    else
      flash[:alert] = t "mess.request_cancel_fail"
    end
    redirect_to profile_path
  end

  private

  def find_request
    @request = Request.find_by id: params[:id]
    return if @request

    flash[:warning] = t "record_not_found"
    redirect_to root_path
  end
end
