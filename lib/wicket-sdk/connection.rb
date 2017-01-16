require 'faraday'

module WicketSDK
  class Connection
    attr_reader :faraday
    attr_reader :last_response

    def initialize(options = {})
      endpoint = options.fetch(:endpoint)
      connection_options = slice_options(options, :proxy, :ssl, :request, :headers, :params)
      adapter_options = Array(
        options.fetch(:adapter, Faraday.default_adapter)
      )
      
      @faraday = Faraday.new(endpoint, connection_options) do |builder|
        # builder.request :json
        builder.adapter(*adapter_options)
      end

      yield(self) if block_given?
    end

    # insert middleware before ParseJson - middleware executed in reverse order -
    #   inserted middleware will run after json parsed
    def use(middleware, *args, &block)
      return if faraday.builder.locked?
      faraday.builder.insert_before(Middleware::ParseJson, middleware, *args, &block)
    end

    def delete(middleware)
      faraday.builder.delete(middleware)
    end

    def run(request_method, path, params = {}, headers = {})
      @last_response = faraday.send(request_method, path, params, headers)
    end

    private

    def slice_options(options, *keys)
      Hash[[keys, options.values_at(*keys)].transpose]
    end
  end
end