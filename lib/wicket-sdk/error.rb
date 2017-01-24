module WicketSDK
  class Error < StandardError; end

  # Custom error class for rescuing from all Wicket API errors
  class ApiError < Error

    # Returns the appropriate WicketSDK::Error subclass based
    # on status and response message
    #
    # @param [Hash] response HTTP response
    # @return [WicketSDK::Error]
    def self.from_response(response)
      status  = response[:status].to_i
      body    = response[:body].to_s
      headers = response[:response_headers]

      if klass =  case status
                  when 400      then WicketSDK::BadRequest
                  when 401      then WicketSDK::Unauthorized
                  when 403      then error_for_403(body)
                  when 404      then WicketSDK::NotFound
                  when 409      then WicketSDK::Conflict
                  when 415      then WicketSDK::UnsupportedMediaType
                  when 422      then WicketSDK::UnprocessableEntity
                  when 400..499 then WicketSDK::ClientError
                  when 500      then WicketSDK::InternalServerError
                  when 501      then WicketSDK::NotImplemented
                  when 502      then WicketSDK::BadGateway
                  when 503      then WicketSDK::ServiceUnavailable
                  when 500..599 then WicketSDK::ServerError
                  end
        klass.new(response)
      end
    end

    def initialize(response=nil)
      @response = response
      super(build_error_message)
    end

    # Returns most appropriate error for 403 HTTP status code
    # @private
    def self.error_for_403(body)
      # TODO: Look at returning more specific error class for some 403 errors.
      WicketSDK::Forbidden
    end

    # Array of validation errors
    # @return [Array<Hash>] Error info
    def errors
      []
    end

    # Status code returned by the Wicket API server.
    #
    # @return [Integer]
    def response_status
      @response[:status]
    end

    private

    def data
      nil
    end

    def response_message
      case data
      when Hash
        data[:message]
      when String
        data
      end
    end

    def response_error
      "Error: #{data[:error]}" if data.is_a?(Hash) && data[:error]
    end

    def response_error_summary
      return nil unless data.is_a?(Hash) && !Array(data[:errors]).empty?

      summary = "\nError summary:\n"
      summary << data[:errors].map do |hash|
        hash.map { |k,v| "  #{k}: #{v}" }
      end.join("\n")

      summary
    end

    def build_error_message
      return nil if @response.nil?

      message =  "#{@response[:method].to_s.upcase} "
      message << redact_url(@response[:url].to_s) + ": "
      message << "#{@response[:status]} - "
      message << "#{response_message}" unless response_message.nil?
      message << "#{response_error}" unless response_error.nil?
      message << "#{response_error_summary}" unless response_error_summary.nil?
      message
    end

    def redact_url(url_string)
      %w{client_secret access_token}.each do |token|
        url_string.gsub!(/#{token}=\S+/, "#{token}=(redacted)") if url_string.include? token
      end
      url_string
    end
  end

  # Raised when a connection could not be established with the Wicket API.
  class ConnectionError < Error; end

  # Raied when a JSON api document could not be parsed
  class InvalidDocument < Error; end

  # Raised on errors in the 400-499 range
  class ClientError < ApiError; end

  # Raised when Wicket API returns a 400 HTTP status code
  class BadRequest < ClientError; end

  # Raised when Wicket API returns a 401 HTTP status code
  class Unauthorized < ClientError; end

  # Raised when Wicket API returns a 403 HTTP status code
  class Forbidden < ClientError; end

  # Raised when Wicket API returns a 404 HTTP status code
  class NotFound < ClientError; end

  # Raised when Wicket API returns a 405 HTTP status code
  class MethodNotAllowed < ClientError; end

  # Raised when Wicket API returns a 409 HTTP status code
  class Conflict < ClientError; end

  # Raised when Wicket API returns a 414 HTTP status code
  class UnsupportedMediaType < ClientError; end

  # Raised when Wicket API returns a 422 HTTP status code
  class UnprocessableEntity < ClientError; end

  # Raised on errors in the 500-599 range
  class ServerError < ApiError; end

  # Raised when Wicket API returns a 500 HTTP status code
  class InternalServerError < ServerError; end

  # Raised when Wicket API returns a 501 HTTP status code
  class NotImplemented < ServerError; end

  # Raised when Wicket API returns a 502 HTTP status code
  class BadGateway < ServerError; end

  # Raised when Wicket API returns a 503 HTTP status code
  class ServiceUnavailable < ServerError; end

end
