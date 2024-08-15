class RoomTypesController < ApplicationController
  def index
    @pagy, @room_types = pagy RoomType.ordered_by_name,
                              limit: Settings.pagy.items
  end

  def show
    @room_type = RoomType.find_by id: params[:id]
    return if @room_type

    flash[:warning] = t "mess.not_found_room"
    redirect_to root_path
  end
end
