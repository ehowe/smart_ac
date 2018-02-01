class GasLeakAlert < SensorAlert
  def set_severity
    self.severity = :critical
  end
end
