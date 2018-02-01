class SensorReading < ApplicationRecord
  belongs_to :device

  scope :graphable,   -> { where(type: %w(Humidity Temperature CoLevel)) }
  scope :humidity,    -> { where(type: "Humidity") }
  scope :temperature, -> { where(type: "Temperature") }
  scope :co_level,    -> { where(type: "CoLevel") }
  scope :unit_health, -> { where(type: "UnitHealth") }

  validates_presence_of :read_at

  after_create :create_alert

  def as_json(options={})
    super(options.merge(methods: :type))
  end

  private

  def create_alert
    if type == 'CoLevel' && value.to_i > 9
      CoAlert.create(sensor_reading: self)
    end

    if type == 'UnitHealth' && %(needs_service needs_new_filter gas_leak).include?(value)
      klass = case value
              when 'needs_service' then NeedsServiceAlert
              when 'needs_new_filter' then NeedsNewFilterAlert
              when 'gas_leak' then GasLeakAlert
              end
      klass.create(message: "Device health for #{device.serial_number} needs attention", sensor_reading: self)
    end
  end
end
