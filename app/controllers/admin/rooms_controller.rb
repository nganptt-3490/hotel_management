class Admin::RoomsController < Admin::BaseController
  def index
    @pagy, @rooms = pagy(Room.ordered_by_room_number,
                         limit: Settings.pagy.items)
  end

  def show
    @room = Room.find_by id: params[:id]
    return if @room

    flash[:warning] = t "mess.not_found_room"
    redirect_to root_path
  end

  def create
    @room = Room.new room_params
    if @room.save
      flash[:success] = t "created"
      redirect_to admin_rooms_path
    else
      flash[:danger] = t "failed"
      render :new
    end
  end

  private

  def room_params
    params.require(:room).permit Room::ROOMS_PERMITTED
  end
end
