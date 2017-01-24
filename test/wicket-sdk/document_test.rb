require 'test_helper'

class WicketSDK::DocumentTest < Minitest::Test
  class CustomResourceB < ::WicketSDK::Resource
  end

  class CustomResourceC < ::WicketSDK::Resource
  end

  it 'can map resource types to custom classes' do
    MAPPING = {
      'resource_b' => CustomResourceB,
      resource_c: CustomResourceC
    }.freeze

    rs = ::WicketSDK::Document.new(MAPPING).parse!(
      'data' => [
        { 'type' => 'resource_a', 'id' => 1, 'attributes' => {} },
        { 'type' => 'resource_b', 'id' => 1, 'attributes' => {} },
        { 'type' => 'resource_c', 'id' => 1, 'attributes' => {} }
      ]
    )

    assert_equal rs.data[0].class, ::WicketSDK::Resource
    assert_equal rs.data[1].class, CustomResourceB
    assert_equal rs.data[2].class, CustomResourceC
  end

  it 'wraps the JSONAPI::Parser invalid document exception' do
    assert_raises WicketSDK::InvalidDocument do
      ::WicketSDK::Document.new.parse!({})
    end
  end
end
