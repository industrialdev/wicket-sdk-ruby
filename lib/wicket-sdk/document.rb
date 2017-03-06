require 'forwardable'
require 'jsonapi/parser'
require 'wicket-sdk/resource'
require 'wicket-sdk/error'
require 'wicket-sdk/resource_collection'

module WicketSDK
  class Document
    extend Forwardable

    attr_reader :data, :included, :errors, :links, :meta, :ready

    delegate ResourceCollection::COLLECTION_METHODS => :resource_collection

    def initialize(resource_class_mappings = {})
      @ready = false
      @resource_class_mappings = resource_class_mappings || {}
    end

    def parse!(document, link_resource_data = true)
      @ready = false
      JSONAPI::Parser::Document.parse!(document)

      parse_data!(document['data'], document['included'])
      link_resource_data! if link_resource_data
      parse_errors!(document['errors'])
      parse_links!(document['links'])
      parse_meta!(document['meta'])
      @ready = true

      self
    rescue JSONAPI::Parser::InvalidDocument => e
      raise WicketSDK::InvalidDocument, e.message
    end

  private

    def parse_data!(data, included_data)
      return unless data

      @data =
        if data.is_a?(Array)
          data.map { |h| resource_from_hash(h) }
        else
          resource_from_hash(data)
        end

      @included = Array(included_data).map { |h| resource_from_hash(h) }
    end

    def resource_index
      return @resource_index unless @resource_index.nil?

      @resource_index = {}
      (Array(@data) + @included).each do |resource|
        resource_identifier = [resource.type, resource.id]
        @resource_index[resource_identifier] = resource
      end

      @resource_index
    end

    def link_resource_data!
      (Array(@data) + @included).each do |resource|
        resource.relationships.each do |_, rel|
          rel.link_resource_data!(resource_index)
        end
      end
    end

    def parse_errors!(errors)
      # TODO: Convert to error object.
      # @errors = Array(errors).map { |h| Error.new(h) }
      @errors = errors
    end

    def parse_links!(links)
      # TODO: Convert to link objects
      @links = links
    end

    def parse_meta!(meta)
      @meta = meta
    end

    def resource_from_hash(data)
      r = resource_class_for(data['type']).new(data)
      r.current_document = self
      r
    end

    def resource_class_for(type)
      @resource_class_mappings[type] || @resource_class_mappings[type.to_sym] || Resource
    end

    def resource_collection
      ResourceCollection.new(@data)
    end
  end
end
