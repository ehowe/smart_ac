class CoAlert < SensorAlert
  before_validation :set_message

  def set_severity
    self.severity = :critical
  end

  def set_message
    self.message = "Carbon monoxide level reported over 9 PPM for device #{self.sensor_reading.device.serial_number}. CO level is #{self.sensor_reading.value} PPM"
  end
end
