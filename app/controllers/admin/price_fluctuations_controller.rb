class Admin::PriceFluctuationsController < Admin::BaseController
  before_action :find_price_fluctuation, only: %i(show update destroy)
  def index
    @fluctuation = PriceFluctuation.new
    @pagy, @fluctuations = paginated_fluctuations
    @start_index = (@pagy.page - 1) * Settings.pagy.items
  end

  def show; end

  def create
    @fluctuation = PriceFluctuation.new fluctuation_params
    if @fluctuation.save
      flash[:success] = t "created"
    else
      flash[:danger] = t "failed"
    end
    redirect_to admin_price_fluctuations_path
  end

  def update
    if @fluctuation.update fluctuation_params
      flash[:success] = t "updated"
    else
      flash[:danger] = t "failed"
    end
    redirect_to admin_price_fluctuations_path
  end

  def destroy
    if @fluctuation.destroy
      flash[:success] = t "deleted"
    else
      flash[:danger] = t "failed"
    end
    redirect_to admin_price_fluctuations_path
  end

  private

  def fluctuation_params
    params.require(:price_fluctuation)
          .permit PriceFluctuation::ATTRIBUTE_PERMITTED
  end

  def find_price_fluctuation
    @fluctuation = PriceFluctuation.find_by id: params[:id]
    return if @fluctuation

    flash[:warning] = t "record_not_found"
    redirect_to admin_price_fluctuations_path
  end

  def paginated_fluctuations
    if params[:search].present?
      pagy(PriceFluctuation.search_by_name(params[:search][:name]),
           limit: Settings.pagy.items)
    else
      pagy(PriceFluctuation, limit: Settings.pagy.items)
    end
  end
end
