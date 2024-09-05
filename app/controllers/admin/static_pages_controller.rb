class Admin::StaticPagesController < Admin::BaseController
  def home
    @requests = Request.all
  end
end
