require "../spec_helper"

describe Zap::Api::ClientSpider do
  it "#scan targets a url and returns the response" do
    with_mock_zap do |mock, client|
      mock.response_body = %({"scan": "7"})
      result = client.client_spider.scan(url: "http://example.com")
      mock.last_path.should eq("/JSON/clientSpider/action/scan/")
      mock.last_params["url"].should eq("http://example.com")
      result["scan"].as_s.should eq("7")
    end
  end

  it "#scan forwards optional tuning params" do
    with_mock_zap do |mock, client|
      client.client_spider.scan(
        url: "http://example.com",
        browser: "firefox-headless",
        context_name: "ctx",
        user_name: "admin",
        subtree_only: true,
        max_crawl_depth: 5,
        number_of_browsers: 4,
        logout_avoidance: false,
      )
      mock.last_params["browser"].should eq("firefox-headless")
      mock.last_params["contextName"].should eq("ctx")
      mock.last_params["userName"].should eq("admin")
      mock.last_params["subtreeOnly"].should eq("true")
      mock.last_params["maxCrawlDepth"].should eq("5")
      mock.last_params["numberOfBrowsers"].should eq("4")
      mock.last_params["logoutAvoidance"].should eq("false")
    end
  end

  it "#scan omits unset optional params" do
    with_mock_zap do |mock, client|
      client.client_spider.scan(url: "http://example.com")
      mock.last_params.has_key?("subtreeOnly").should be_false
      mock.last_params.has_key?("maxCrawlDepth").should be_false
      mock.last_params.has_key?("browser").should be_false
    end
  end

  it "#stop sends the scan id" do
    with_mock_zap do |mock, client|
      client.client_spider.stop(7)
      mock.last_path.should eq("/JSON/clientSpider/action/stop/")
      mock.last_params["scanId"].should eq("7")
    end
  end

  it "#status reports progress for a scan id" do
    with_mock_zap do |mock, client|
      mock.response_body = %({"status": "42"})
      result = client.client_spider.status(7)
      mock.last_path.should eq("/JSON/clientSpider/view/status/")
      mock.last_params["scanId"].should eq("7")
      result["status"].as_s.should eq("42")
    end
  end
end
