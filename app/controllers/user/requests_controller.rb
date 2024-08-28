class User::RequestsController < User::BaseController
  before_action :set_request, only: %i(update)
  before_action :set_room_type, only: :create

  def create
    ActiveRecord::Base.transaction do
      @request = current_user.requests.build request_params
      save_request_and_create_history
      flash[:success] = t "request.create_success"
      redirect_to profile_path
    end
  rescue StandardError => e
    flash.now[:error] = t("request.create_failure") + ": #{e.message}"
    respond_to(&:turbo_stream)
  end

  def update
    if @request.histories.create(status: :canceled)
      flash[:notice] = t "mess.request_cancelled"
    else
      flash[:alert] = t "mess.request_cancel_fail"
    end
    redirect_to profile_path
  end

  def payment
    @request = Request.find params[:id]

    if @request.update(paymented_at: Time.current)
      flash[:success] = t "updated"
    else
      flash[:danger] = t "failed"
    end
    redirect_to request_path
  end

  private

  def request_params
    params.require(:request).permit(Request::ATTRIBUTE_PERMITTED)
          .merge(user_id: current_user.id)
  end

  def set_room_type
    @room_type = RoomType.find_by(id: params.dig(:request, :room_type_id))
    return if @room_type

    flash[:alert] = t "room_type.not_found"
  end

  def set_request
    @request = Request.find_by id: params[:id]
    return if @request

    flash[:warning] = t "record_not_found"
    redirect_to root_path
  end

  def save_request_and_create_history
    @request.save!
    @request.histories.create!(status: :pending)
  end
end
