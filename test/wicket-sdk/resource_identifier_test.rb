require 'test_helper'

class WicketSDK::ResourceIdentifierTest < Minitest::Test
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
end
