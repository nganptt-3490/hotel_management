class Admin::RoomsController < Admin::BaseController
  before_action :find_room_id, only: %i(update destroy show)

  def index
    @room = Room.new
    @pagy, @rooms = pagy(Room.ordered_by_room_number,
                         limit: Settings.pagy.items)
  end

  def show; end

  def create
    @room = Room.new room_params
    if @room.save
      flash[:success] = t "created"
    else
      flash[:danger] = t "failed"
    end
    redirect_to admin_rooms_path
  end

  def update
    if @room.update room_params
      flash[:success] = t "updated"
    else
      flash[:danger] = t "failed"
    end
    redirect_to admin_room_path
  end

  def destroy
    if @room.destroy
      flash[:success] = t "deleted"
    else
      flash[:danger] = t "failed"
    end
    redirect_to admin_rooms_path
  end

  private

  def room_params
    params.require(:room).permit Room::ROOMS_PERMITTED
  end

  def find_room_id
    @room = Room.find_by id: params[:id]

    return if @room

    flash[:warning] = I18n.t("record_not_found")
    redirect_to admin_rooms_path
  end
end
