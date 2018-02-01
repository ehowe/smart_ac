class API::ApplicationController < ApplicationController
  before_action :encrypted_api_authentication
  respond_to :json

  # this is for the UI to make API requests.  the user is already logged in, so we don't need to encrypt the api token

  def encrypted_api_authentication
    authorization_header = request.headers["Authorization"]

    return render json: {"errors" => "no authorization header sent"}, status: 401 unless authorization_header

    auth_type, base64_encrypted_value = authorization_header.split

    encrypted_value = Base64.strict_decode64(base64_encrypted_value)

    begin
      unencrypted_value = SmartAC.auth_key.private_decrypt(encrypted_value)
    rescue OpenSSL::PKey::RSAError
      return render json: {"errors" => "there was a problem decrypting the header value"}, status: 401
    end

    case auth_type
    when 'Token'
      @consumer ||= User.find_by(api_key: unencrypted_value) || Device.find_by(api_key: unencrypted_value)

      render json: {"errors" => "invalid api key"}, status: 401 unless @consumer
    when 'Basic'
      email, password = unencrypted_value.split(":")
      user = User.find_for_authentication(email: email)

      if user.valid_password?(password)
        @consumer = user
      end

      return render json: {"errors" => "invalid username or password"}, status: 401 unless @consumer
    end
  end

  def basic_api_authentication
    @consumer ||= User.find_by(api_key: params[:api_key]) || Device.find_by(api_key: params[:api_key])

    return render json: {"errors" => "invalid api key"}, status: 401 unless @consumer
  end
end

