require 'wicket-sdk/result_set'

module WicketSDK
  class ResourceEndpoint
    def initialize(client, route)
      @client = client
      @route = route
    end

    def all
      jsonapi_request(:get, @route)
    end

    def find(resource_id)
      jsonapi_request(:get, "#{@route}/#{resource_id}")
    end

    protected

    def jsonapi_request(*args)
      parse_result_set @client.connection.run(*args)
    end

    def parse_result_set(response)
      ResultSet.new(@client.resource_class_mappings).tap do |rs|
        # Support for async faraday requests
        response.on_complete do
          rs.parse!(response.body || {})
        end
      end
    end

  end
end
