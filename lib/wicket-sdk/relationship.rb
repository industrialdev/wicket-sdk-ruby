require 'forwardable'
require 'wicket-sdk/resource_collection'

module WicketSDK
  class Relationship
    extend Forwardable
    attr_reader :data, :links, :meta

    delegate ResourceCollection::COLLECTION_METHODS => :resource_collection

    def initialize(relationship)
      @data = parse_data!(relationship['data'])
      @links = relationship['links']
      @meta = relationship['meta']
    end

    def single?
      !many?
    end

    def many?
      @data.is_a?(Array)
    end

    # @api private
    def link_resource_data!(resource_index)
      if many?
        @data.map! do |ri|
          resource_index[ri.as_tuple] || ri
        end
      elsif !@data.nil?
        @data = resource_index[@data.as_tuple] || @data
      end
    end

    private

    def parse_data!(data)
      return unless data

      @data =
        if data.is_a?(Array)
          data.map { |h| ResourceIdentifier.new(h) }
        else
          ResourceIdentifier.new(data)
        end
    end

    def resource_collection
      ResourceCollection.new(@data)
    end
  end
end
