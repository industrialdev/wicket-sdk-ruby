require 'test_helper'
require 'pry'

class WicketSDK::ResourceTest < Minitest::Test
  def setup
    @sample_resource = WicketSDK::Resource.new(
      'type' => 'email',
      'id' => '1234',
      'attributes' => {
        'address' => 'foo@bar.com'
      }
    )
  end

  it 'is also a resource identifier' do
    assert @sample_resource.is_a? WicketSDK::ResourceIdentifier
  end

  it 'can be converted back to json' do
    expected = {
      'type' => 'email',
      'id' => '1234',
      'attributes' => {
        'address' => 'foo@bar.com'
      }
    }
    assert_equal expected, @sample_resource.to_json
  end

  describe 'attributes' do
    it 'attributes returns a hash' do
      resource = WicketSDK::Resource.new('type' => 'email')
      assert_instance_of Hash, resource.attributes
    end

    it 'defaults to empty hash when no attributes specified' do
      res1 = WicketSDK::Resource.new('type' => 'email', 'id' => '123')
      assert_empty res1.attributes
    end

    it 'defaults to empty hash when attributes are nil' do
      res2 = WicketSDK::Resource.new(
        'type' => 'email', 'id' => '1234', 'attributes' => nil
      )
      assert_empty res2.attributes
    end

    it 'can access attributes with string or symbol' do
      res = @sample_resource

      assert_equal 'foo@bar.com', res['address']
      assert_equal 'foo@bar.com', res[:address]
      assert_nil res[:missing_attribute]
    end

    it 'handles nil name argument' do
      assert_nil @sample_resource[nil]
    end
  end
end
