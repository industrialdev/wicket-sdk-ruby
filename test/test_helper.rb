$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'wicket-sdk'

require 'minitest/autorun'

class Minitest::Test
  extend Minitest::Spec::DSL # Add it blocks
end
