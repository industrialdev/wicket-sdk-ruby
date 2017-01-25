require 'test_helper'

class WicketSDK::DocumentTest < Minitest::Test
  class CustomResourceB < WicketSDK::Resource
  end

  class CustomResourceC < WicketSDK::Resource
  end

  SAMPLE_RESOURCES = {
    'data' => [
      { 'type' => 'resource_a', 'id' => 1, 'attributes' => {} },
      { 'type' => 'resource_b', 'id' => 2, 'attributes' => {} },
      { 'type' => 'resource_c', 'id' => 3, 'attributes' => {} }
    ]
  }

  MAPPING = {
    'resource_b' => CustomResourceB,
    resource_c: CustomResourceC
  }.freeze

  it 'can map resource types to custom classes' do
    rs = WicketSDK::Document.new(MAPPING).parse!(SAMPLE_RESOURCES)

    assert_equal rs.data[0].class, WicketSDK::Resource
    assert_equal rs.data[1].class, CustomResourceB
    assert_equal rs.data[2].class, CustomResourceC
  end

  it 'forwards useful utility methods to a resource collection' do
    rs = WicketSDK::Document.new.parse!(SAMPLE_RESOURCES)

    assert_equal 1, rs.first.id
    assert_equal 2, rs[1].id
    assert_equal 3, rs.last.id
    assert_equal [1,2,3], rs.map(&:id)
    assert_equal 1, rs.select { |r| r.type == 'resource_b' }.size

    assert_instance_of WicketSDK::ResourceCollection, rs.primary
  end

  it 'wraps the JSONAPI::Parser invalid document exception' do
    assert_raises WicketSDK::InvalidDocument do
      WicketSDK::Document.new.parse!({})
    end
  end
end
