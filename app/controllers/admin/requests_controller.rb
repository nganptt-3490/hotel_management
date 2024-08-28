class Admin::RequestsController < Admin::BaseController
  before_action :find_request_by_id, only: %i(show send_total_cost)
  def index
    @pagy, @requests = pagy(Request.includes(:user).sorted_by_date,
                            limit: Settings.pagy.items)
    @start_index = (@pagy.page - 1) * Settings.pagy.items
  end

  def show
    @lost_utilities = LostUtility.by_request(@request.id)
    @total_cost = calculate_total_cost(@request)
    @utilities = Utility.for_room_type(@request.room_type_id)
    @rooms = available_room(@request.room_type_id,
                            @request.start_date,
                            @request.end_date)
    return if @request

    flash[:warning] = t "request.not_found"
    redirect_to root_path
  end

  def accept
    ActiveRecord::Base.transaction do
      @request = Request.find params[:id]
      room_id = params[:request][:room_id]

      @request.update!(room_id:, reject_reason: nil)
      @request.histories.create! status: :accepted
      create_room_costs @request

      flash[:success] = t "request.accept_success"
      redirect_to admin_requests_path
    rescue ActiveRecord::RecordInvalid => e
      handle_error(e, :accept)
      respond_to(&:turbo_stream)
    end
  end

  def reject
    ActiveRecord::Base.transaction do
      @request = Request.find params[:id]
      reject_reason = params[:request][:reject_reason]

      @request.update_attribute(:reject_reason, reject_reason)
      @request.update_attribute(:room_id, nil)
      @request.histories.create! status: :rejected
      delete_related_room_costs @request

      flash[:success] = t "request.reject_success"
      redirect_to admin_requests_path
    rescue ActiveRecord::RecordInvalid => e
      handle_error(e, :reject)
      respond_to(&:turbo_stream)
    end
  end

  def send_total_cost
    if @request.update(payment: params[:total_cost])
      flash[:success] = t "updated"
    else
      flash[:danger] = t "failed"
    end
    redirect_to admin_request_path
  end

  private
  def handle_error exception, type
    flash[:error] = t("request.#{type}_failed") + ": #{exception.message}"
    raise ActiveRecord::Rollback
  end

  def create_room_costs request
    start_date = request.start_date
    end_date = request.end_date

    (start_date...end_date).each do |use_date|
      price_fluctuation = PriceFluctuation
                          .find_by("start_date <= ? AND end_date >= ?",
                                   use_date, use_date)
      price_fluctuation_id = price_fluctuation&.id
      RoomCost.create!(request_id: request.id,
                       use_date:, price_fluctuation_id:)
    end
  end

  def delete_related_room_costs request
    RoomCost.by_request_id(request.id).destroy_all
  end

  def calculate_total_cost request
    room_costs_total = request.room_costs.reduce(0) do |sum, room_cost|
      sum + calculate_room_cost(room_cost, request.room_type)
    end

    lost_utility_costs_total = @lost_utilities.reduce(0) do |sum, lost_utility|
      sum + lost_utility.quantity * lost_utility.utility.cost
    end

    room_costs_total + lost_utility_costs_total
  end

  def find_request_by_id
    @request = Request.find_by id: params[:id]
  end
end
