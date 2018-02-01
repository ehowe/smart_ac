FactoryBot.define do
  factory :user do
    email                  "user@example.com"
    password               "password"
    password_confirmation  "password"
    role                   "admin"
  end

  factory :device do
    serial_number "11223344556677889900AA"
    firmware_version "12.3"
    api_key "FFEEDDCCBBAA00998877665544332211"
  end
end
