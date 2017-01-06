require 'test_helper'

class Wicket::VersionTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Wicket::SDK::VERSION
  end
end
