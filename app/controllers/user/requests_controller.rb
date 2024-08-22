class User::RequestsController < ApplicationController
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

  private

  def request_params
    params.require(:request).permit(Request::ATTRIBUTE_PERMITTED)
          .merge(user_id: current_user.id)
  end

  def set_room_type
    @room_type = RoomType.find_by(id: params.dig(:request, :room_type_id))
    return if @room_type

    flash[:alert] = t "room_type.not_found"
    redirect_to root_path
  end
end
