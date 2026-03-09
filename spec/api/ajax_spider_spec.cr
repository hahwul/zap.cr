require "../spec_helper"

describe Zap::Api::AjaxSpider do
  it "#scan" do
    with_mock_zap do |mock, client|
      client.ajax_spider.scan(url: "http://example.com")
      mock.last_path.should eq("/JSON/ajaxSpider/action/scan/")
      mock.last_params["url"].should eq("http://example.com")
    end
  end

  it "#scan_as_user" do
    with_mock_zap do |mock, client|
      client.ajax_spider.scan_as_user("ctx", "admin", url: "http://example.com")
      mock.last_params["contextName"].should eq("ctx")
      mock.last_params["userName"].should eq("admin")
    end
  end

  it "#stop" do
    with_mock_zap do |mock, client|
      client.ajax_spider.stop
      mock.last_path.should eq("/JSON/ajaxSpider/action/stop/")
    end
  end

  it "#status" do
    with_mock_zap do |mock, client|
      mock.response_body = %({"status": "running"})
      result = client.ajax_spider.status
      result["status"].as_s.should eq("running")
    end
  end

  it "#results" do
    with_mock_zap do |mock, client|
      mock.response_body = %({"results": []})
      client.ajax_spider.results(start: 0, count: 5)
      mock.last_params["start"].should eq("0")
      mock.last_params["count"].should eq("5")
    end
  end

  it "#set_option_max_crawl_depth" do
    with_mock_zap do |mock, client|
      client.ajax_spider.set_option_max_crawl_depth(10)
      mock.last_params["Integer"].should eq("10")
    end
  end

  it "#set_option_browser_id" do
    with_mock_zap do |mock, client|
      client.ajax_spider.set_option_browser_id("firefox-headless")
      mock.last_params["String"].should eq("firefox-headless")
    end
  end

  it "#set_option_max_duration" do
    with_mock_zap do |mock, client|
      client.ajax_spider.set_option_max_duration(60)
      mock.last_params["Integer"].should eq("60")
    end
  end
end
