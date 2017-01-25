module WicketSDK
  class ResourceCollection < SimpleDelegator
    COLLECTION_METHODS = [
      :[], :each, :size, :map, :select,
      :detect, :reduce, :first, :last,
      :primary, :of_type,
      :with_attribute, :with_truthy_attribute
    ].freeze

    def initialize(data = [])
      data = [data].compact! unless data.is_a?(Array)
      super(data)
    end

    def primary(is_primary = true)
      with_truthy_attribute(:primary, is_primary)
    end

    def of_type(type)
      as_collection do
        if type
          type = type.to_s

          select do |res|
            if res.is_a? Resource
              res.type == type
            else
              res['type'] == type
            end
          end
        end
      end
    end

    def with_attribute(attr, value, options = {})
      strict_compare = options.fetch(:strict) { false }

      if !strict_compare && (value == true || value == false)
        return with_truthy_attribute(attr, value)
      end

      as_collection do
        select { |res| res.is_a?(Resource) && value == res[attr] }
      end
    end

    def with_truthy_attribute(attr, value = true)
      value = !!value
      as_collection do
        select { |res| res.is_a?(Resource) && value == !!res[attr] }
      end
    end

    def as_collection
      data = yield if block_given?
      data ||= []
      self.class.new(data)
    end
  end
end
