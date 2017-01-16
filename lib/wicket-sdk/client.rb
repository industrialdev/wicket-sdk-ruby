require 'wicket-sdk/connection'
require 'wicket-sdk/configurable'
require 'wicket-sdk/default'
require 'wicket-sdk/authentication'


module WicketSDK
  # Client for the Wicket API
  #
  # @see TODO: API_DOCS_URL
  class Client
    include WicketSDK::Configurable
    include WicketSDK::Authentication

    def initialize(options = {})
      # Use options passed in, but fall back to module defaults
      WicketSDK::Configurable.keys.each do |key|
        instance_variable_set(:"@#{key}", options[key] || WicketSDK.instance_variable_get(:"@#{key}"))
      end

      yield self if block_given?
    end

    def access_token=(value)
      reset_connection
      @access_token = value
    end

    def connection(rebuild = false)
      return @connection if @connection && !rebuild

      conn_options = connection_options.merge(endpoint: api_endpoint)

      @connection = Connection.new(conn_options) do |conn|
        conn.faraday.authorization :Bearer, access_token if token_authenticated?
      end
    end

    private

    def reset_connection
      @connection = nil
    end
  end
end