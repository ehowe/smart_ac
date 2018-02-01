class SensorReadingSerializer < ActiveModel::Serializer
  attributes :id, :type, :value, :read_at
end
