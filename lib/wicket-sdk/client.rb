require 'wicket-sdk/connection'
require 'wicket-sdk/configurable'
require 'wicket-sdk/default'
require 'wicket-sdk/authentication'
require 'wicket-sdk/warnable'
require 'wicket-sdk/query_builder'

module WicketSDK
  # Client for the Wicket API
  #
  # @see TODO: API_DOCS_URL
  class Client
    include WicketSDK::Configurable
    include WicketSDK::Warnable
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

    def alive
      connection.run(:head, '/').status
    end

    def alive?
      alive == 200
    end

    def people
      QueryBuilder.new(self, '/people')
    end

    def organizations
      QueryBuilder.new(self, '/organizations')
    end

    def addresses
      QueryBuilder.new(self, '/addresses')
    end

    def organization_addresses(uuid)
      QueryBuilder.new(self, "/organizations/#{uuid}/addresses")
    end

    def phones
      QueryBuilder.new(self, '/phones')
    end

    private

    def reset_connection
      @connection = nil
    end
  end
end
