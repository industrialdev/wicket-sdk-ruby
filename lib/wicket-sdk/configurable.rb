module WicketSDK
  # Configuration options for {Client}, defaulting to values
  # in {Default}
  module Configurable
    attr_accessor :access_token, :connection_options, :user_agent
    attr_writer :api_endpoint

    class << self

      # List of configurable keys for {WicketSDK::Client}
      # @return [Array] of option keys
      def keys
        @keys ||= [
          :access_token,
          :connection_options,
          :user_agent,
          :api_endpoint
        ]
      end
    end

    # Set configuration options using a block
    def configure
      yield self
    end

    # Reset configuration options to default values
    def reset!
      WicketSDK::Configurable.keys.each do |key|
        instance_variable_set(:"@#{key}", WicketSDK::Default.options[key])
      end
      self
    end

    alias setup reset!

    # Compares client options to a Hash of requested options
    #
    # @param opts [Hash] Options to compare with current client options
    # @return [Boolean]
    def same_options?(opts)
      opts.hash == options.hash
    end

    def api_endpoint
      File.join(@api_endpoint, '')
    end

    private

    def options
      Hash[WicketSDK::Configurable.keys.map{ |key| [key, instance_variable_get(:"@#{key}")]}]
    end
  end
end