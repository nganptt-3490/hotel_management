class User::RoomTypesController < User::BaseController
  def index
    @room_type_ids = get_room_type_available_ids params[:start_date],
                      params[:end_date]
    @pagy, @room_types = pagy(RoomType.by_ids(@room_type_ids)
                                      .ordered_by_name, limit: Settings.pagy.items)
  end

  def show
    @room_type = RoomType.find_by id: params[:id]
    return if @room_type

    flash[:warning] = t "mess.not_found_room"
    redirect_to root_path
  end

  def search
    start_date = params[:search][:start_date]
    end_date = params[:search][:end_date]

    @room_type_ids = get_room_type_available_ids start_date, end_date
    redirect_to room_types_url start_date:, end_date:
  end

  private

  def valid_date? date_string
    Date.parse date_string
  rescue StandardError
    false
  end
end
