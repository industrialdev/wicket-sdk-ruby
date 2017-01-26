require 'test_helper'

class WicketSDK::ResourceTest < Minitest::Test
  def sample_resource
    WicketSDK::Resource.new(
      'type' => 'email',
      'id' => '1234',
      'attributes' => {
        'address' => 'foo@bar.com'
      }
    )
  end

  it 'is also a resource identifier' do
    assert sample_resource.is_a? WicketSDK::ResourceIdentifier
  end

  describe 'attributes' do

    it 'defaults to empty hash when no attributes specified' do
      res1 = WicketSDK::Resource.new(
        'type' => 'email', 'id' => '1234'
      )

      res2 = WicketSDK::Resource.new(
        'type' => 'email', 'id' => '1234', 'attributes' => nil
      )

      assert_instance_of Hash, res1.attributes
      assert_empty res1.attributes

      assert_instance_of Hash, res2.attributes
      assert_empty res2.attributes
    end

    it 'can access attributes with string or symbol' do
      res = sample_resource

      assert_equal 'foo@bar.com', res['address']
      assert_equal 'foo@bar.com', res[:address]
      assert_nil res[:missing_attribute]
    end

    it 'handles nil name argument' do
      assert_nil sample_resource[nil]
    end
  end
end
