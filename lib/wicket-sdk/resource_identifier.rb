require 'wicket-sdk/relationship'

module WicketSDK
  class ResourceIdentifier
    attr_reader :id, :type, :meta

    def initialize(resource)
      if resource.is_a? ResourceIdentifier
        @id = resource.id
        @type = resource.type
        @meta = resource.meta
      else
        @id = resource['id']
        @type = resource['type']
        @meta = resource['meta']
      end
    end

    def [](_)
      nil
    end

    def ==(other)
      return false if !other
      return false unless other.respond_to?(:type) && other.respond_to?(:id)

      self.type == other.type && self.id == other.id
    end

    def as_tuple
      [@type, @id]
    end

    def resource?
      false
    end
  end
end
