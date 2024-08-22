class Admin::RequestsController < Admin::BaseController
  def index
    @pagy, @requests = pagy(Request.includes(:user).sorted_by_date,
                            limit: Settings.pagy.items)
    @start_index = (@pagy.page - 1) * Settings.pagy.items
  end

  def show
    @request = Request.find_by id: params[:id]
    return if @request

    flash[:warning] = t "request.not_found"
    redirect_to root_path
  end
end
