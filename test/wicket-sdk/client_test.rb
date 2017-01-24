require 'test_helper'

class WicketSDK::ClientTest < Minitest::Test
  it 'handles connection errors' do
    stub_get('/')
      .to_raise(::Faraday::ConnectionFailed)

    assert_raises WicketSDK::ConnectionError do
      WicketSDK.connection.run(:get, '/')
    end
  end

  it 'handles timeout errors' do
    stub_get('/')
      .to_timeout

    assert_raises WicketSDK::ConnectionError do
      WicketSDK.connection.run(:get, '/')
    end
  end

  it 'handles client errors' do
    stub_get('/')
      .to_return(status: 404, body: 'something irrelevant')

    assert_raises WicketSDK::ClientError do
      WicketSDK.connection.run(:get, '/')
    end
  end

  it 'handles server errors' do
    stub_get('/')
      .to_return(status: 501, body: 'something irrelevant')

    assert_raises WicketSDK::ServerError do
      WicketSDK.connection.run(:get, '/')
    end
  end
end
