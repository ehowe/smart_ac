class AddTypeToSensorAlerts < ActiveRecord::Migration[5.1]
  def change
    add_column :sensor_alerts, :type, :string
  end
end
