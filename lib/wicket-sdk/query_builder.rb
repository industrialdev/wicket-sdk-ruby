require 'wicket-sdk/document'

module WicketSDK
  class QueryBuilder
    def initialize(client, route)
      @client = client
      @route = route
      @query_params = {
        include: [],
        fields: [],
        filter: {},
        sort: [],
        page: {}
      }
    end

    def all
      jsonapi_request(:get, @route, to_params)
    end

    def find(resource_id)
      jsonapi_request(:get, "#{@route}/#{resource_id}", to_params)
    end

    # Pass in your resource.data.to_json
    def save(json_resource)
      jsonapi_request(:patch, "#{@route}/#{json_resource['id']}", "data"=> json_resource)
    end

    # Set pagination settings
    #
    # @example set page to 10
    #   WicketSDK::QueryBuilder.new(client, route).page(10)
    #
    # @example set page and size
    #   WicketSDK::QueryBuilder.new(client, route).page(2, 25)
    #
    # @return [WicketSDK::QueryBuilder] self for fluent queries
    def page(number, size = nil)
      @query_params[:page][:number] = number
      @query_params[:page][:size] = size if size
      self
    end

    # Set JSONAPI includes
    #
    # @example include side loaded resource
    #   WicketSDK::QueryBuilder.new(client, route).includes(:people)
    #
    # @example include nested resource
    #   WicketSDK::QueryBuilder.new(client, route).includes('people.addresses')
    #
    # @return [WicketSDK::QueryBuilder] self for fluent queries
    def includes(*args)
      @query_params[:include] += args
      self
    end

    # Set JSONAPI sparse fields
    #
    # @example limit fields being returned by resource
    #   WicketSDK::QueryBuilder.new(client, route).fields(
    #     people: :first_name,
    #     addresses: [:state_name, :province_code]
    #   )
    #
    # @return [WicketSDK::QueryBuilder] self for fluent queries
    def fields(*args)
      @query_params[:fields] += args
      self
    end

    # Set Wicket specific filters
    #
    # @example filter response results
    #   WicketSDK::QueryBuilder.new(client, route).filter(age_gt: 21)
    #
    # @return [WicketSDK::QueryBuilder] self for fluent queries
    def filter(filters = {})
      @query_params[:filter].merge!(filters)
      self
    end

    # Set JSONAPI sort settings.
    #
    # @example sort by multiple fields / directions
    #   WicketSDK::QueryBuilder.new(client, route).sort(:created_at, number: :desc)
    #
    # @return [WicketSDK::QueryBuilder] self for fluent queries
    def sort(*args)
      @query_params[:sort] += args
      self
    end

    # @return [String] query as a query string
    def to_query_string
      Faraday::Utils.build_nested_query(to_params)
    end

    def to_s
      to_query_string
    end

    def to_params
      params = {}
      params[:include] = include_to_params unless invalid_param? :include
      params[:fields] = fields_to_params unless invalid_param? :fields
      params[:filter] = @query_params[:filter] unless invalid_param? :filter
      params[:sort] = sort_to_params unless invalid_param? :sort
      params[:page] = @query_params[:page] unless invalid_param? :page
      params
    end

    protected

    def invalid_param?(param)
      @query_params[param].empty?
    end

    def include_to_params
      @query_params[:include].flatten.map! do |s|
        s.to_s.strip
      end.join(',')
    end

    def fields_to_params
      params = @query_params[:fields].each_with_object({}) do |field_hash, fields|
        next unless field_hash.is_a? Hash

        field_hash.each do |filter, filter_value|
          fields[filter] ||= []
          fields[filter] << filter_value
        end
      end

      params.map do |filter, filter_value|
        [filter, filter_value.join(',')]
      end.to_h
    end

    def sort_to_params
      @query_params[:sort].flatten.map do |value|
        if value.is_a? Hash
          value.map do |field, dir|
            dir.to_sym == :desc ? "-#{field}" : field
          end
        else
          value.to_s
        end
      end.join(',')
    end

    def jsonapi_request(*args)
      document_from_response @client.connection.run(*args)
    end

    def document_from_response(response)
      Document.new(@client.resource_class_mappings).tap do |rs|
        # Support for async faraday requests
        response.on_complete do
          rs.parse!(response.body || {})
        end
      end
    end
  end
end
