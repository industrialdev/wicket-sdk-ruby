require 'wicket-sdk/error'

module WicketSDK
  module Middleware
    # Faraday middleware used to parse json responses
    class RaiseError < Faraday::Middleware
      def call(environment)
        @app.call(environment).on_complete do |env|
          error = WicketSDK::ApiError.from_response(env)
          raise error if error
        end
      rescue Faraday::ConnectionFailed, Faraday::TimeoutError
        raise WicketSDK::ConnectionError, environment
      end
    end
  end
end
