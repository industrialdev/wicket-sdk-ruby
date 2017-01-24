$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'wicket-sdk'
require 'wicket-sdk/client'

require 'webmock/minitest'
require 'minitest/autorun'
require 'support/stub_request_helpers'

WebMock.disable_net_connect!

class Minitest::Test
  extend Minitest::Spec::DSL # Add it blocks
  include StubRequestHelpers
end
