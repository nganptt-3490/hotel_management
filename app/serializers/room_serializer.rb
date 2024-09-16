class RoomSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :status, :room_type

  def room_type
    object.room_type.name
  end
end
