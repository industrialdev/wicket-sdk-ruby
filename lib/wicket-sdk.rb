require 'wicket-sdk/configurable'
require 'wicket-sdk/default'

module WicketSDK
  autoload :VERSION, 'wicket-sdk/version'
  autoload :Client, 'wicket-sdk/client'

  class << self
    include WicketSDK::Configurable

    def client
      return @client if defined?(@client) && @client.same_options?(options)

      @client = WicketSDK::Client.new(options)
    end

    private

    def respond_to_missing?(method_name, include_private = false)
      client.respond_to?(method_name, include_private)
    end

    def method_missing(method_name, *args, &block)
      return super unless client.respond_to?(method_name)

      client.send(method_name, *args, &block)
    end
  end
end

WicketSDK.setup
