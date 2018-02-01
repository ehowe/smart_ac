require 'rails_helper'
require 'rspec_api_documentation/dsl'


resource "Authentication" do
  let(:user) { create(:user) }

  explanation <<-EOF
  The API supports 2 methods of authentication.  Both forms are required to be encrypted by a keypair that is secret to this application.  Each device will contain its own public key to perform this encryption.  A sample key is available below

  <pre>#{File.read("#{Rails.root}/spec/support/public_key.pem")}</pre>

  The 2 valid authentication forms are Basic and Token and must be specified in the Authorization header.  To generate this header follow these steps:

  1. If using Basic auth, combine the username and password: `username:password`
  2. Using the public key, encrypt the token or string from step 1
  3. Base64 encode the encrypted string from step 2
  4. Specify `Basic` or `Token` at the beginning of the Authorization header and specify the string from step 3
  EOF

  header "Authorization", :authorization_header

  get "/api/users/current" do
    context "without any authorization" do
      example "Returns 'no authorization header' message" do
        do_request

        expect(status).to eq(401)
        expect(response_body).to match(/no authorization header sent/)
      end
    end

    context "with an unencrypted header" do
      let(:authorization_header) { "Basic #{Base64.strict_encode64('not_encrypted')}" }

      example "Returns 'decryption error' message" do
        do_request

        expect(response_body).to match(/there was a problem decrypting the header value/)
        expect(status).to eq(401)
      end
    end

    context "with bad basic authorization" do
      let(:authorization_header) { EncryptionHelper.new(resource: user, custom_string_to_encrypt: "not the password", auth_type: :basic).generate_header }

      example "Returns 'invalid username or password' message" do
        do_request

        expect(response_body).to match(/invalid username or password/)
        expect(status).to eq(401)
      end
    end

    context "with a bad api token" do
      let(:authorization_header) { EncryptionHelper.new(resource: user, custom_string_to_encrypt: "not the api key", auth_type: :token).generate_header }

      example "Returns an 'invalid api key' message" do
        do_request

        expect(response_body).to match(/invalid api key/)
        expect(status).to eq(401)
      end
    end

    context "with a good basic auth" do
      let(:authorization_header) { EncryptionHelper.new(resource: user, auth_type: :basic).generate_header }

      example "Authorizes with basic auth" do
        do_request

        expect(status).to eq(200)
      end
    end

    context "with a good token auth" do
      let(:authorization_header) { EncryptionHelper.new(resource: user, auth_type: :token).generate_header }

      example "Authorizes with token auth" do
        do_request

        expect(status).to eq(200)
      end
    end
  end
end
