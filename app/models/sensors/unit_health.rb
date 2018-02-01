class UnitHealth < SensorReading
  validates_length_of :value, maximum: 150
end
