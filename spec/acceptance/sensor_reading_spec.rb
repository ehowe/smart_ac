require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource "Sensor Readings" do
  let(:user)        { create(:user) }
  let(:device)      { create(:device) }
  let(:auth_header) { EncryptionHelper.new(resource: device, auth_type: :token).generate_header }

  header "Authorization", :auth_header

  post "/api/sensor_readings" do
    explanation "Devices will use this endpoint to upload sensor data"

    parameter :type, "Sensor reading type.  Must be one of CoLevel, Humidity, Temperature, or UnitHealth", required: true, scope: :sensor_reading
    parameter :value, "Sensor value", required: true, scope: :sensor_reading
    parameter :read_at, "Timestamp of the sensor reading", required: true, scope: :sensor_reading
    parameter :device, "Id of the device reporting the sensor reading", required: true

    [["CoLevel", "8"], ["Humidity", "40"], ["Temperature", "30"], ["UnitHealth", "healthy"], ["UnitHealth", "needs_service"], ["UnitHealth", "needs_new_filter"], ["UnitHealth", "gas_leak"]].each do |array|
      example "Creates a #{array[0]} sensor reading with value: #{array[1]}" do
        do_request(sensor_reading: {type: array[0], value: array[1], read_at: Time.now}, device: device.id)

        expect(status).to eq(200)

        body = JSON.parse(response_body)

        expect(body["value"]).to eq(array[1])
        expect(body["type"]).to eq(array[0])
      end
    end
  end

  post "/api/sensor_readings/bulk_upload" do
    explanation "This endpoint supports bulk upload of sensor readings.  The request can contain up to 500 sensor readings.  Each sensor reading must contain a type, value, and read_at timestamp.  Any readings missing any of those values will cause the bulk upload process to fail"

    parameter :sensor_readings, "Array of sensor readings"
    parameter :value, "Value of the sensor: sensor_readings[][value]"
    parameter :type, "Type of sensor reading: sensor_readings[][type]"
    parameter :read_at, "Timestamp of the sensor reading: sensor_readings[][read_at]"
    parameter :device, "Id of the device reporting the sensor readings", required: true

    example "Uploads sensor data in bulk" do
      sensor_readings = Array.new(500) { {type: "UnitHealth", value: %w(healthy needs_service needs_new_filter gas_leak).sample, read_at: Time.now} }

      expect {
        do_request(sensor_readings: sensor_readings, device: device.id)
      }.to change { SensorReading.count }.by(500)

      expect(status).to eq(201)
      expect(response_body).to match(/bulk upload complete/)
    end
  end
end
