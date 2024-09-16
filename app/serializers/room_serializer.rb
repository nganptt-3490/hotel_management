class RoomSerializer < ActiveModel::Serializer
  attributes :id, :room_number, :description, :status, :room_type

  def room_type
    object.room_type.name
  end
end
