require 'test_helper'

class WicketSDK::ResourceCollectionTest < Minitest::Test
  def create(resources)
    WicketSDK::ResourceCollection.new(resources)
  end

  RESOURCE_IDS = [
    { 'type' => 'email', 'id' => '0001' },
    { 'type' => 'phone', 'id' => '0002' },
    { 'type' => 'email', 'id' => '0003' },
    { 'type' => 'phone', 'id' => '0004' },
    { 'type' => 'phone', 'id' => '0005' },
  ].freeze

  describe '#primary' do
     it 'returns empty results when only containing resource ids' do
      collection = create(RESOURCE_IDS).primary
      assert_empty collection
    end

    it 'filters primary records' do
      data = RESOURCE_IDS.map { |r| WicketSDK::Resource.new(r) }
      data[2].attributes['primary'] = true
      data[4].attributes['primary'] = true

      collection = create(data).primary

      assert_instance_of WicketSDK::ResourceCollection, collection
      assert_equal 2, collection.size
      assert_equal '0003', collection[0].id
      assert_equal '0005', collection[1].id
    end

    it 'filters non-primary records' do
      data = RESOURCE_IDS.map { |r| WicketSDK::Resource.new(r) }
      data[2].attributes['primary'] = true
      data[4].attributes['primary'] = true

      collection = create(data).primary(false)

      assert_instance_of WicketSDK::ResourceCollection, collection
      assert_equal 3, collection.size
    end
  end

  describe '#of_type' do
    it 'returns empty results when called with null type' do
      collection = create(RESOURCE_IDS).of_type(nil)

      assert_instance_of WicketSDK::ResourceCollection, collection
      assert_empty collection
    end

    it 'returns only phone resources' do
      collection = create(RESOURCE_IDS).of_type('phone')

      assert_instance_of WicketSDK::ResourceCollection, collection
      assert_equal 3, collection.size
    end
  end

  describe '#with_attribute' do
    it 'uses truthy check when value is a Boolean' do
      data = RESOURCE_IDS.map { |r| WicketSDK::Resource.new(r) }
      data[2].attributes['foo'] = true
      data[3].attributes['foo'] = nil

      collection = create(data).with_attribute(:foo, true)

      assert_instance_of WicketSDK::ResourceCollection, collection
      assert_equal 1, collection.size

      collection = create(data).with_attribute(:foo, false)

      assert_instance_of WicketSDK::ResourceCollection, collection
      assert_equal 4, collection.size
    end

    it 'ignores truthy check when strict option is passed' do
      data = RESOURCE_IDS.map { |r| WicketSDK::Resource.new(r) }
      data[2].attributes['foo'] = true
      data[3].attributes['foo'] = false

      collection = create(data).with_attribute(:foo, true, strict: true)

      assert_instance_of WicketSDK::ResourceCollection, collection
      assert_equal 1, collection.size

      collection = create(data).with_attribute(:foo, false, strict: true)

      assert_instance_of WicketSDK::ResourceCollection, collection
      assert_equal 1, collection.size
    end

    it 'filters resource with attribute foo=bar' do
      data = RESOURCE_IDS.map { |r| WicketSDK::Resource.new(r) }
      data[2].attributes['foo'] = 'bar'
      data[4].attributes['foo'] = 'bar'

      collection = create(data).with_attribute(:foo, 'bar')

      assert_instance_of WicketSDK::ResourceCollection, collection
      assert_equal 2, collection.size
    end
  end
end
