class User < ApplicationRecord
  include Apiable
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :user_devices
  has_many :device_records, class_name: "Device", through: :user_devices

  validates_inclusion_of :role, in: %w(admin customer)

  def admin?
    role == 'admin'
  end

  def active_for_authentication?
    super && self.is_active?
  end

  # currently there are only admins.  this will need to be refined before exposing to customers
  def devices
    admin? ? Device.all : device_records
  end
end
