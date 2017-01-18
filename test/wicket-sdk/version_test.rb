require 'test_helper'

class WicketSDK::VersionTest < Minitest::Test
  it 'has a valid version number' do
    refute_nil ::WicketSDK::VERSION
  end
end
