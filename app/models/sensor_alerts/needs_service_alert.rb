class NeedsServiceAlert < SensorAlert
  def set_severity
    self.severity = :warning
  end
end
