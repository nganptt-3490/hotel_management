class Api::V1::Admin::RoomsController < Api::V1::ApplicationController
  before_action :authenticate_user
  before_action :set_room, only: %i(show update destroy)
  def index
    @pagy, @rooms = pagy(Room, limit: Settings.pagy.items)
    @start_index = (@pagy.page - 1) * Settings.pagy.items

    render json: {
      rooms: ActiveModelSerializers::SerializableResource.new(@rooms,
                                                              each_serializer:
                                                              RoomSerializer),
      pagy: {
        page: @pagy.page,
        items: @pagy.vars[:limit],
        pages: @pagy.pages
      },
      start_index: @start_index
    }
  end

  def show
    render json: @room
  end

  def create
    @room = Room.new room_params
    if @room.save
      render json: @room, status: :created
    else
      render json: @room.errors, status: :unprocessable_entity
    end
  end

  def update
    if @room.update room_params
      render json: @room, status: :ok
    else
      render json: @room.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @room.destroy
    head :no_content
  end

  private
  def room_params
    params.require(:room).permit Room::ROOMS_PERMITTED
  end

  def set_room
    @room = Room.find_by(id: params[:id])
    return if @room

    render json: {}, status: :not_found
  end
end
