module WicketSDK
  class ResourceCollection < SimpleDelegator
    COLLECTION_METHODS = [
      :[], :each, :size, :map, :select,
      :detect, :reduce, :first, :last,
      :primary
    ].freeze

    def initialize(data = [])
      data = [data].compact! unless data.is_a?(Array)
      super(data)
    end

    def primary
      data = select do |res|
        res.respond_to?(:attributes) && res[:primary]
      end

      self.class.new(data)
    end
  end
end
