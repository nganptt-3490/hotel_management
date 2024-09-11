module ReviewsHelper
  def room_options rooms, selected_room
    options_for_select(
      rooms.map{|room| [room.room_number, room.room_number]},
      selected: selected_room
    )
  end

  def status_options selected_status
    options_for_select(
      Review.statuses.map{|key, value| [t("review.statuses.#{key}"), value]},
      selected: selected_status
    )
  end
end
