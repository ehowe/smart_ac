class AddSeverityToSensorAlerts < ActiveRecord::Migration[5.1]
  def change
    add_column :sensor_alerts, :severity, :integer, null: false
  end
end
