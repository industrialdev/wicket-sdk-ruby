module StubRequestHelpers
  def stub_delete(url)
    stub_request(:delete, wicket_api_url(url))
  end

  def stub_get(url)
    stub_request(:get, wicket_api_url(url))
  end

  def stub_head(url)
    stub_request(:head, wicket_api_url(url))
  end

  def stub_patch(url)
    stub_request(:patch, wicket_api_url(url))
  end

  def stub_post(url)
    stub_request(:post, wicket_api_url(url))
  end

  def stub_put(url)
    stub_request(:put, wicket_api_url(url))
  end

  def fixture_path
    File.expand_path("../fixtures", __FILE__)
  end

  def fixture(file)
    File.new(File.join(fixture_path, file))
  end

  def json_response(file)
    {
      :body => fixture(file),
      :headers => {
        :content_type => 'application/json; charset=utf-8'
      }
    }
  end

  def wicket_api_url(url)
    return url if url =~ /^http/

    File.join(WicketSDK.api_endpoint, url)
  end
end
