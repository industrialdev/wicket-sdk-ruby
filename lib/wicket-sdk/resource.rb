require 'wicket-sdk/relationship'
require 'wicket-sdk/resource_identifier'

module WicketSDK
  class Resource < ResourceIdentifier
    attr_accessor :current_document
    attr_reader :attributes, :relationships, :links

    def initialize(resource)
      super

      @attributes = resource['attributes'] || {}
      @links = resource['links']

      parse_relationships!(resource['relationships'])
    end

    def [](attribute_name)
      return nil unless attribute_name

      attributes[attribute_name.to_s]
    end

    def relationship(relationship_name)
      return nil unless relationship_name
      relationships[relationship_name.to_s]
    end

    def resource?
      true
    end

    def to_json
      {
        "type" => self.type,
        "id" => self.id,
        "attributes" => self.attributes
      }
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
