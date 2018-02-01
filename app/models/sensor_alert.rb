class SensorAlert < ApplicationRecord
  cattr_accessor(:severity_mapping)

  enum severity: [:critical, :warning, :notice]

  belongs_to :sensor_reading
  has_one :hidden_by, class_name: "User", foreign_key: 'user_id'

  before_validation :set_severity, on: :create

  default_scope { order(severity: :asc, created_at: :desc) }

  private

  def set_severity
    self.severity = :notice
  end
end
