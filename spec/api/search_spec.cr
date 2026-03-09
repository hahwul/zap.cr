require "../spec_helper"

describe Zap::Api::Search do
  it "#messages_by_url_regex" do
    with_mock_zap do |mock, client|
      client.search.messages_by_url_regex(".*example\\.com.*")
      mock.last_path.should eq("/JSON/search/view/messagesByUrlRegex/")
      mock.last_params["regex"].should eq(".*example\\.com.*")
    end
  end

  it "#messages_by_request_regex with pagination" do
    with_mock_zap do |mock, client|
      client.search.messages_by_request_regex("password", start: 0, count: 50)
      mock.last_params["regex"].should eq("password")
      mock.last_params["start"].should eq("0")
      mock.last_params["count"].should eq("50")
    end
  end

  it "#messages_by_response_regex" do
    with_mock_zap do |mock, client|
      client.search.messages_by_response_regex("Set-Cookie")
      mock.last_path.should eq("/JSON/search/view/messagesByResponseRegex/")
    end
  end

  it "#messages_by_header_regex" do
    with_mock_zap do |mock, client|
      client.search.messages_by_header_regex("X-Custom-Header")
      mock.last_path.should eq("/JSON/search/view/messagesByHeaderRegex/")
    end
  end

  it "#urls_by_url_regex" do
    with_mock_zap do |mock, client|
      client.search.urls_by_url_regex(".*api.*", base_url: "http://example.com")
      mock.last_path.should eq("/JSON/search/view/urlsByUrlRegex/")
      mock.last_params["baseurl"].should eq("http://example.com")
    end
  end

  it "#urls_by_response_regex" do
    with_mock_zap do |mock, client|
      client.search.urls_by_response_regex("error")
      mock.last_path.should eq("/JSON/search/view/urlsByResponseRegex/")
    end
  end

  it "#har_by_url_regex" do
    with_mock_zap do |mock, client|
      mock.response_body = %({"log": {}})
      result = client.search.har_by_url_regex(".*example.*")
      mock.last_path.should eq("/OTHER/search/other/harByUrlRegex/")
      result.should be_a(String)
    end
  end
end
