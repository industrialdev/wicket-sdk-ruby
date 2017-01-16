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
  end
end
