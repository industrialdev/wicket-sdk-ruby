require 'forwardable'
require 'wicket-sdk/resource_collection'

module WicketSDK
  class Relationship
    extend Forwardable
    attr_reader :data, :links, :meta

    delegate ResourceCollection::COLLECTION_METHODS => :resource_collection

    def initialize(relationship)
      @data = relationship['data']
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
          ri = [ri['type'], ri['id']]
          resource_index[ri]
        end
      elsif !@data.nil?
        ri = [@data['type'], @data['id']]
        @data = resource_index[ri]
      end
    end

    private

    def resource_collection
      ResourceCollection.new(@data)
    end
  end
end
