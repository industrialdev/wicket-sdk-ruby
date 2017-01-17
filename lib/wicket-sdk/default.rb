require 'wicket-sdk/version'

module WicketSDK
  # Default configuration options for {Client}
  module Default
    # Default endpoint for wicket.
    # TODO: Should we provide a default endpoint?
    API_ENDPOINT = 'https://api.wicket.io'.freeze

    # Default User Agent header string
    USER_AGENT = "wicket-sdk-ruby/#{WicketSDK::VERSION}".freeze

    class << self
      # Configuration options
      # @return [Hash]
      def options
        Hash[
          WicketSDK::Configurable.keys.map do |key|
            [key, send(key)]
          end
        ]
      end

      # Default access token from ENV
      # @return [String]
      def access_token
        ENV['WICKET_ACCESS_TOKEN']
      end

      # Default API app key from ENV
      # @return [String]
      def client_id
        ENV['WICKET_CLIENT_ID']
      end

      # Default API app secret from ENV
      # @return [String]
      def client_secret
        ENV['WICKET_CLIENT_SECRET']
      end

      # Default API endpoint from ENV or {API_ENDPOINT}
      # @return [String]
      def api_endpoint
        ENV['WICKET_API_ENDPOINT'] || API_ENDPOINT
      end

      # Default User-Agent header string from ENV or {USER_AGENT}
      # @return [String]
      def user_agent
        ENV['WICKET_USER_AGENT'] || USER_AGENT
      end

      # Default options for Faraday::Connection
      # @return [Hash]
      def connection_options
        {
          headers: {
            user_agent: user_agent
          }
        }
      end
    end
  end
end
