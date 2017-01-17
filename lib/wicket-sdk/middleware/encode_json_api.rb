require 'json' unless defined?(::JSON)

module WicketSDK
  module Middleware
    # Middleware used to encode jsonapi.org compatible requests.
    class EncodeJsonApi < Faraday::Middleware
      MIME_TYPE = 'application/vnd.api+json'.freeze

      def call(env)
        env[:request_headers]['Content-Type'] ||= MIME_TYPE
        env[:request_headers]['Accept'] ||= MIME_TYPE

        match_content_type(env) do |data|
          env[:body] = encode(data)
        end

        @app.call(env)
      end

      private

      def encode(data)
        ::JSON.dump(data)
      end

      def match_content_type(env)
        if process_request?(env)
          yield env[:body] unless env[:body].respond_to?(:to_str)
        end
      end

      def process_request?(env)
        type = request_type(env)
        body?(env) && (type.empty? || type == MIME_TYPE)
      end

      def body?(env)
        body = env[:body]
        body && !(body.respond_to?(:to_str) && body.empty?)
      end

      def request_type(env)
        type = env[:request_headers]['Content-Type'].to_s
        type = type.split(';', 2).first if type.index(';')
        type
      end
    end
  end
end
