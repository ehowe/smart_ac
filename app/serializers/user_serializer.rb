class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :is_active, :role, :api_key
end
