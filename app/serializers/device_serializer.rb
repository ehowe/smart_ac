class DeviceSerializer < ActiveModel::Serializer
  attributes :id, :firmware_version, :serial_number, :api_key

  attribute :created_at, key: :registered_at
end
