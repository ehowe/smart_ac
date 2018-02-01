require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource "Devices" do
  let(:user)          { create(:user) }
  let(:serial_number) { SecureRandom.hex(11) }
  let(:auth_header)   { EncryptionHelper.new(resource: user, auth_type: :basic).generate_header }

  header "Authorization", :auth_header

  post "/api/devices" do
    explanation "The POST /devices endpoint is used by Smart AC units for registration.  A user and password are expected to be sent by the client"

    parameter :serial_number, "Unit Serial Number", required: true, scope: :device
    parameter :firmware_version, "Unit Firmware Version", required: true, scope: :device

    example "Register a device" do
      do_request(device: {serial_number: serial_number, firmware_version: "1.2"})

      expect(status).to eq(200)
      body = JSON.parse(response_body)

      expect(body["firmware_version"]).to eq("1.2")
      expect(body["serial_number"]).to eq(serial_number)
      expect(body["api_key"]).not_to be_nil
    end
  end
end
