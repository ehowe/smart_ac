SmartAC.auth_key = OpenSSL::PKey::RSA.new(ENV["AUTH_KEY"] || File.read("config/private_key.pem"))
