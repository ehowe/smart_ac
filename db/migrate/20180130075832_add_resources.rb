class AddResources < ActiveRecord::Migration[5.1]
  def change
    enable_extension "pgcrypto"

    create_table :devices, id: :uuid do |t|
      t.string :firmware_version, null: false
      t.string :serial_number, null: false, length: 22
      t.string :api_key, null: false, length: 32

      t.timestamps null: false
    end

    add_index :devices, :serial_number, unique: true

    create_table :sensor_readings, id: :uuid do |t|
      t.datetime :read_at, null: false
      t.string :type
      t.string :value
      t.uuid :device_id, null: false

      t.timestamps null: false
    end

    add_index :sensor_readings, :device_id
    add_index :sensor_readings, :type
    add_index :sensor_readings, :read_at

    create_table :user_devices, id: :uuid do |t|
      t.uuid :user_id, null: false
      t.uuid :device_id, null: false

      t.timestamps null: false
    end

    add_index :user_devices, [:user_id, :device_id], unique: true
    add_index :user_devices, :user_id
    add_index :user_devices, :device_id

    create_table :sensor_alerts, id: :uuid do |t|
      t.datetime :hidden_at
      t.text :message, null: false
      t.uuid :sensor_reading_id, null: false
      t.uuid :user_id

      t.timestamps null: false
    end

    add_index :sensor_alerts, :sensor_reading_id
    add_index :sensor_alerts, :user_id
  end
end
