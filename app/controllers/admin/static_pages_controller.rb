class Admin::StaticPagesController < Admin::BaseController
  def home
    @search = Request.ransack(params[:q])
    @requests = @search.result
  end
end
