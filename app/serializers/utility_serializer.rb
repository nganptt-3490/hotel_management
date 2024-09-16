class UtilitySerializer < ActiveModel::Serializer
  attributes :id, :type, :name, :quantity, :cost,
             :created_at, :updated_at
end
