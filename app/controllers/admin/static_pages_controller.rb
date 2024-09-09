class Admin::StaticPagesController < Admin::BaseController
  skip_load_and_authorize_resource
  def home
    authorize! :read, :home
    @search = Request.ransack(params[:q])
    @requests = @search.result
  end
end
