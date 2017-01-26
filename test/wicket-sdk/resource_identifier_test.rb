require 'test_helper'

class WicketSDK::ResourceIdentifierTest < Minitest::Test
  class DummyClass
    def jsonapi_resource_identifier
      WicketSDK::ResourceIdentifier.new('type' => 'email', 'id' => '001')
    end
  end

  it 'parses resource identifier fields' do
    meta = {
      'a' => 'b',
      'c' => 'd'
    }

    res = WicketSDK::ResourceIdentifier.new(
      'type' => 'email', 'id' => '1234', 'meta' => meta
    )

    assert_equal 'email', res.type
    assert_equal '1234', res.id
    assert_equal meta, res.meta
  end

  it 'can compare' do
    res1 = WicketSDK::ResourceIdentifier.new('type' => 'email', 'id' => '001')
    res2 = WicketSDK::ResourceIdentifier.new('type' => 'email', 'id' => '001')
    res3 = WicketSDK::ResourceIdentifier.new('type' => 'email', 'id' => '002')
    res4 = WicketSDK::ResourceIdentifier.new('type' => 'phone', 'id' => '001')

    assert_equal res1, res2
    refute_equal res1, res3
    refute_equal res1, res4
  end

  it 'can compare any class if it responds to jsonapi_resource_identifier' do
    res1 = WicketSDK::ResourceIdentifier.new('type' => 'email', 'id' => '001')
    dummy_class = DummyClass.new
    random_class = Object.new

    assert_equal res1, dummy_class
    refute_equal res1, random_class
  end
end
