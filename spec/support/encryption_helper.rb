class EncryptionHelper
  cattr_accessor(:public_key)

  self.public_key = OpenSSL::PKey::RSA.new(File.read("#{Rails.root}/spec/support/public_key.pem"))

  attr_reader :resource, :auth_type, :custom_string_to_encrypt

  def initialize(options={})
    @resource = options[:resource]
    @auth_type = options[:auth_type]
    @custom_string_to_encrypt = options[:custom_string_to_encrypt]

    raise "auth type must be specified" unless @auth_type
  end

  def generate_header
    case @auth_type
    when :basic
      raise "invalid resource type" unless @resource.is_a?(User)
      header_name = "Basic"
      string_to_encrypt = "#{@resource.email}:#{self.custom_string_to_encrypt || @resource.password}"
    when :token
      header_name = "Token"
      string_to_encrypt = self.custom_string_to_encrypt || @resource.api_key
    else
      raise "invalid auth type"
    end
    "#{header_name} #{Base64.strict_encode64(self.class.public_key.public_encrypt(string_to_encrypt))}"
  end
end
