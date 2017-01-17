require 'securerandom'

module WicketSDK
  # Authentication methods for {Client}
  module Authentication

    # Indicates if the client was supplied an API
    # access token
    #
    # @see TODO
    # @return [Boolean]
    def token_authenticated?
      !@access_token.nil?
    end

    def authorize_person(person_uuid, expires = 600)
      require 'jwt'
      self.access_token = JWT.encode(
        authorize_person_jwt_payload(person_uuid, expires), client_secret, 'HS256'
      )

      self
    rescue LoadError
      wicket_sdk_warn 'Please install jwt gem for JWT support'
      self
    end

    private

    def authorize_person_jwt_payload(person_uuid, expires)
      iat = Time.now.to_i

      {
        iat: iat,
        jti: SecureRandom.uuid,
        exp: iat + expires,
        sub: person_uuid
      }
    end
  end
end
