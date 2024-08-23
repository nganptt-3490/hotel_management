class User::RoomTypesController < User::BaseController
  def index
    @room_type_ids = get_room_type_available_ids params[:start_date],
                                                 params[:end_date],
                                                 params[:min_price],
                                                 params[:max_price],
                                                 params[:utility_ids]
    @pagy, @room_types = pagy(RoomType.by_ids(@room_type_ids)
                                      .ordered_by_name,
                              limit: Settings.pagy.items)
    @utilities = Utility.all
  end

  def show
    @room_type = RoomType.find_by id: params[:id]
    @request = Request.new(room_type_id: @room_type.id)
    request_ids = Request.by_room_type(@room_type.id).pluck(:id)
    @reviews = Review.accepted.by_request_ids(request_ids)
                     .ordered_by_review_time
    return if @room_type

    flash[:warning] = t "mess.not_found_room"
    redirect_to root_path
  end

  def search
    @room_type_ids = get_room_type_available_ids(params[:search][:start_date],
                                                 params[:search][:end_date],
                                                 params[:search][:min_price],
                                                 params[:search][:max_price],
                                                 params[:search][:utility_ids])
    redirect_to room_types_url(search_params)
  end

  private

  def valid_date? date_string
    Date.parse date_string
  rescue StandardError
    false
  end

  def search_params
    params.require(:search).permit(RoomType::ATTRIBUTE_PERMITTED +
                                  [utility_ids: []])
  end
end
