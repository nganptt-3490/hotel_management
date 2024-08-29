class Admin::PriceFluctuationsController < Admin::BaseController
  def index
    if params[:search].present?
      @pagy, @fluctuations = pagy(PriceFluctuation
                                  .search_by_name(params[:search][:name]),
                                  limit: Settings.pagy.items)
    else
      @pagy, @fluctuations = pagy(PriceFluctuation, limit: Settings.pagy.items)
    end
    @start_index = (@pagy.page - 1) * Settings.pagy.items
  end
end
