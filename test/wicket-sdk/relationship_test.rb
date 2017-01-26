require 'test_helper'

class WicketSDK::RelationshipTest < Minitest::Test
  RESOURCE_IDS = [
    { 'type' => 'email', 'id' => '0001' },
    { 'type' => 'phone', 'id' => '0002' },
    { 'type' => 'email', 'id' => '0003' }
  ].freeze

  RESOURCE_IDENTIFIERS = RESOURCE_IDS.map do |data|
    WicketSDK::ResourceIdentifier.new(data)
  end.freeze

  it 'parses single relationships' do
    rel = WicketSDK::Relationship.new(
      'data' => RESOURCE_IDS.first
    )

    assert rel.single?
    refute rel.many?

    assert_equal 1, rel.size
    assert_instance_of WicketSDK::ResourceIdentifier, rel.data
  end

  it 'parses many relationships' do
    rel = WicketSDK::Relationship.new(
      'data' => RESOURCE_IDS
    )

    assert rel.many?
    refute rel.single?

    assert_equal 3, rel.size
    assert_instance_of WicketSDK::ResourceIdentifier, rel.data[0]
    assert_instance_of WicketSDK::ResourceIdentifier, rel.data[1]
    assert_instance_of WicketSDK::ResourceIdentifier, rel.data[2]
  end

  describe 'resource linking' do
    it 'maintains relationship identifier not present in document index' do
      rel_single = WicketSDK::Relationship.new('data' => RESOURCE_IDS.first)
      rel_many = WicketSDK::Relationship.new('data' => RESOURCE_IDS)

      rel_single.link_resource_data!({})
      rel_many.link_resource_data!({})

      assert_equal RESOURCE_IDENTIFIERS[0], rel_single.data
      assert_equal RESOURCE_IDENTIFIERS[0], rel_many.data[0]
      assert_equal RESOURCE_IDENTIFIERS[1], rel_many.data[1]
      assert_equal RESOURCE_IDENTIFIERS[2], rel_many.data[2]
    end

    it 'links resources' do
      rel_single = WicketSDK::Relationship.new('data' => RESOURCE_IDS.last)
      rel_many = WicketSDK::Relationship.new('data' => RESOURCE_IDS)

      document_index = {
        ['email', '0003'] => WicketSDK::Resource.new(RESOURCE_IDS.last)
      }

      rel_single.link_resource_data!(document_index)
      rel_many.link_resource_data!(document_index)

      assert_equal RESOURCE_IDENTIFIERS.last, rel_single.data
      assert_equal RESOURCE_IDENTIFIERS[0], rel_many.data[0]
      assert_equal RESOURCE_IDENTIFIERS[1], rel_many.data[1]
      assert_equal RESOURCE_IDENTIFIERS[2], rel_many.data[2]
      assert_instance_of WicketSDK::Resource, rel_many.data[2]
    end
  end


end
