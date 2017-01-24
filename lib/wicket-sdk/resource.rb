require 'wicket-sdk/relationship'

module WicketSDK
  class Resource
    attr_accessor :current_document
    attr_reader :id, :type, :attributes, :relationships, :links, :meta

    def initialize(resource)
      @id = resource['id']
      @type = resource['type']
      @attributes = resource['attributes'] || {}
      @meta = resource['meta']
      @linsk = resource['links']

      parse_relationships!(resource['relationships'])
    end

    def [](attr)
      return nil unless attr

      attributes[attr.to_s]
    end

    def relationship(name)
      return nil unless name
      relationships[name.to_s]
    end

    private

    def parse_relationships!(relationships)
      @relationships = {}
      (relationships || {}).map do |key, h|
        @relationships[key] = Relationship.new(h)
      end
    end

    def method_missing(method, *args)
      return super unless (rel = relationship(method))
      rel
    end

    def respond_to_missing?(symbol, include_all = false)
      return true if relationship(symbol)
      super
    end
  end
end
