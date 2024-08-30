module RequestsHelper
  def request_status request
    latest_history = request.histories.last
    if latest_history.blank?
      t "request.status.pending"
    else
      t "request.status.#{latest_history.status}"
    end
  end

  def get_room_number request
    if request.room_id.blank?
      t "request.table.room_not_assigned"
    else
      request.room.room_number
    end
  end

  def calculate_room_cost room_cost, room_type
    price = if room_cost.use_date.saturday? || room_cost.use_date.sunday?
              room_type.price_weekend
            else
              room_type.price_weekday
            end

    if room_cost.price_fluctuation.present?
      room_cost.price_fluctuation.rate * price
    else
      price
    end
  end

  def canceled? request
    request.histories.last.canceled?
  end

  def is_started? request
    Time.zone.today > request.start_date
  end
end
