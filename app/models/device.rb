class Device < ApplicationRecord
  include Apiable
  has_many :user_devices
  has_many :users, through: :user_devices
  has_many :sensor_readings
end
