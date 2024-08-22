class User::RequestsController < User::BaseController
  before_action :set_request, only: %i(update)
  before_action :set_room_type, only: :create

  def create
    @request = current_user.requests.build request_params
    if @request.save
      flash[:success] = t "request.create_success"
      redirect_to profile_path
    else
      respond_to(&:turbo_stream)
    end
  end

  def update
    if @request.update deleted_at: Time.current
      flash[:notice] = t "mess.request_cancelled"
    else
      flash[:alert] = t "mess.request_cancel_fail"
    end
    redirect_to profile_path
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
end
