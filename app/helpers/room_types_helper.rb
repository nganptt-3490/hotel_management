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

  def check_room_available start_date = nil, end_date = nil
    requested_room_ids = check_requested_room(start_date, end_date)
    available_rooms = Room.excluding_ids(requested_room_ids)
                          .active
    available_rooms.pluck :id
  end

  def get_room_type_available_ids start_date = nil, end_date = nil
    available_room_ids = check_room_available(start_date, end_date)
    Room.by_ids(available_room_ids).pluck(:room_type_id).uniq
  end
end
