require 'test_helper'

class WicketSDK::VersionTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::WicketSDK::VERSION
  end
end
