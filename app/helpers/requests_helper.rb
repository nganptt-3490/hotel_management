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
end
