# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

if Rails.env.development?
  user = User.create!(email: 'eugene+smartac@xtreme-computers.net', password: 'topsecret', password_confirmation: 'topsecret', role: 'admin')
  4.times { |i| User.create(email: "eugene+smartac#{i}@gmail.com", password: "topsecret#{i}", password_confirmation: "topsecret#{i}", role: 'admin') }
  2.times { Device.create!(serial_number: SecureRandom.hex(11), firmware_version: "1.2") }

  user.devices.each do |d|
    5.times do
      Temperature.create(value: (0..40).to_a.sample, device: d, read_at: Time.now)
      Humidity.create(value: (0..100).to_a.sample, device: d, read_at: Time.now)
      CoLevel.create(value: (0..20).to_a.sample, device: d, read_at: Time.now)
      UnitHealth.create(value: %w(healthy needs_service needs_new_filter gas_leak).sample, device: d, read_at: Time.now)
    end
  end
end
