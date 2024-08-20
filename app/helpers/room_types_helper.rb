module RoomTypesHelper
  def check_requested_room start_date = nil, end_date = nil
    requests = []
    if start_date.present?
      if end_date.present?
        requests = Request.accepted
                          .within_date_range(start_date, end_date)
      end
      if end_date.blank?
        requests = Request.accepted
                          .with_start_date(start_date)
      end
    elsif end_date.present?
      requests = Request.accepted
                        .with_end_date(end_date)
    end
    requests.pluck :room_id
  end

  def check_room_available start_date = nil, end_date = nil,
    min_price = nil, max_price = nil
    requested_room_ids = check_requested_room(start_date, end_date)
    available_rooms = Room.excluding_ids(requested_room_ids)
                          .active
                          .by_room_type_price_range(min_price, max_price)

    available_rooms.pluck(:id)
  end

  def get_room_type_available_ids start_date = nil, end_date = nil,
    min_price = nil, max_price = nil, utility_ids = []

    utility_ids ||= []
    available_room_ids = check_room_available start_date, end_date,
                                              min_price, max_price
    room_type_ids = Room.by_ids(available_room_ids).pluck(:room_type_id).uniq

    selected_utility_ids = utility_ids.map(&:to_i).reject(&:zero?)

    if selected_utility_ids.any?
      room_type_ids_with_utilities = RoomType
                                     .with_utilities(selected_utility_ids)
                                     .pluck(:id)
    end

    room_type_ids &= room_type_ids_with_utilities || room_type_ids

    room_type_ids
  end
end
