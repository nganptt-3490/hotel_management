class Admin::RequestsController < Admin::BaseController
  before_action :find_request_by_id, only: %i(show send_total_cost)
  def index
    @q = Request.ransack(params[:q])
    @pagy, @requests = pagy(@q.result.includes(:user, :room_type, :room)
                            .references(:user, :room_type, :room)
                            .sorted_by_date,
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

      update_request_and_create_history(@request, room_id, :accepted)
      create_room_costs @request
      UserMailer.request_accept(@request.user, @request).deliver_now

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

      update_request_and_create_history(@request, nil, :rejected, reject_reason)
      delete_related_room_costs @request
      UserMailer.request_reject(@request.user, @request).deliver_now

      flash[:success] = t "request.reject_success"
      redirect_to admin_requests_path
    rescue ActiveRecord::RecordInvalid => e
      handle_error(e, :reject)
      respond_to(&:turbo_stream)
    end
  end

  def send_total_cost
    update_total_cost(@request, params[:total_cost])
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
    return if @request

    flash[:warning] = t "record_not_found"
    redirect_to admin_requests_path
  end

  def update_request_and_create_history request, room_id, status,
    reject_reason = nil
    request.update!(room_id:, reject_reason:)
    request.histories.create!(status:)
  end

  def update_total_cost request, total_cost
    if request.update(payment: total_cost)
      flash[:success] = t "updated"
    else
      flash[:danger] = t "failed"
    end
  end
end
