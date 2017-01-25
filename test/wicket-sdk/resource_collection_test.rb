require 'test_helper'

class WicketSDK::ResourceCollectionTest < Minitest::Test
  def create(resources)
    WicketSDK::ResourceCollection.new(resources)
  end

  it 'returns empty results when only containing resource ids' do
    collection = create(
      [
        { 'type' => 'email', 'id' => '1234' },
        { 'type' => 'email', 'id' => '1235' },
      ]
    )

    assert_empty collection.primary
  end

  it 'supports utility method for filtering primary records' do
    collection = create(
      [
        WicketSDK::Resource.new('type' => 'email', 'id' => '1234'),
        WicketSDK::Resource.new('type' => 'email', 'id' => '1235', 'attributes' => { 'primary' => true }),
        WicketSDK::Resource.new('type' => 'email', 'id' => '1236'),
      ]
    )

    assert_instance_of WicketSDK::ResourceCollection, collection.primary
    assert_equal 1, collection.primary.size
    assert_equal '1235', collection.primary[0].id
  end
end
