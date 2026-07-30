require "../spec_helper"

describe Zap::Api::Spider do
  it "#scan" do
    with_mock_zap do |mock, client|
      mock.response_body = %({"scan": "1"})
      result = client.spider.scan(url: "http://example.com")
      mock.last_path.should eq("/JSON/spider/action/scan/")
      mock.last_params["url"].should eq("http://example.com")
      result["scan"].as_s.should eq("1")
    end
  end

  it "#scan recurses by default" do
    with_mock_zap do |mock, client|
      mock.response_body = %({"scan": "1"})
      client.spider.scan(url: "http://example.com")
      # recurse must default to true so the spider crawls discovered links.
      mock.last_params["recurse"].should eq("true")
      # maxChildren is omitted (no limit) unless explicitly set.
      mock.last_params["maxChildren"]?.should be_nil
    end
  end

  it "#scan honours recurse: false and maxChildren" do
    with_mock_zap do |mock, client|
      mock.response_body = %({"scan": "1"})
      client.spider.scan(url: "http://example.com", recurse: false, max_children: 10)
      mock.last_params["recurse"].should eq("false")
      mock.last_params["maxChildren"].should eq("10")
    end
  end

  it "#scan sends the exact expected query params" do
    with_mock_zap do |mock, client|
      mock.response_body = %({"scan": "2"})
      client.spider.scan(
        url: "http://example.com",
        context_name: "ctx",
        subtree_only: true,
        recurse: true,
        max_children: 5,
      )
      mock.last_path.should eq("/JSON/spider/action/scan/")
      mock.last_params["url"].should eq("http://example.com")
      mock.last_params["contextName"].should eq("ctx")
      mock.last_params["subtreeOnly"].should eq("true")
      mock.last_params["recurse"].should eq("true")
      mock.last_params["maxChildren"].should eq("5")
    end
  end

  it "#scan with context" do
    with_mock_zap do |mock, client|
      mock.response_body = %({"scan": "2"})
      client.spider.scan(url: "http://example.com", context_name: "ctx", subtree_only: true)
      mock.last_params["contextName"].should eq("ctx")
      mock.last_params["subtreeOnly"].should eq("true")
    end
  end

  it "#scan_as_user" do
    with_mock_zap do |mock, client|
      mock.response_body = %({"scan": "3"})
      client.spider.scan_as_user(1, 0, url: "http://example.com")
      # ZAP's spider scanAsUser mandates the numeric ids and accepts no
      # contextName / userName at all.
      mock.last_params["contextId"].should eq("1")
      mock.last_params["userId"].should eq("0")
      mock.last_params["contextName"]?.should be_nil
      mock.last_params["userName"]?.should be_nil
      mock.last_params["recurse"].should eq("true")
    end
  end

  it "#scan_as_user forwards recurse and max_children" do
    with_mock_zap do |mock, client|
      mock.response_body = %({"scan": "3"})
      client.spider.scan_as_user(2, 5, url: "http://example.com", recurse: false, max_children: 7)
      mock.last_params["recurse"].should eq("false")
      mock.last_params["maxChildren"].should eq("7")
    end
  end

  it "#status" do
    with_mock_zap do |mock, client|
      mock.response_body = %({"status": "50"})
      result = client.spider.status(0)
      mock.last_params["scanId"].should eq("0")
      result["status"].as_s.should eq("50")
    end
  end

  it "#results" do
    with_mock_zap do |mock, client|
      mock.response_body = %({"results": ["http://example.com/a", "http://example.com/b"]})
      client.spider.results(scan_id: 3)
      mock.last_params["scanId"].should eq("3")
    end
  end

  it "#results omits scanId when not given" do
    with_mock_zap do |mock, client|
      client.spider.results
      mock.last_path.should eq("/JSON/spider/view/results/")
      mock.last_params["scanId"]?.should be_nil
    end
  end

  it "#pause and #resume" do
    with_mock_zap do |mock, client|
      client.spider.pause(1)
      mock.last_path.should eq("/JSON/spider/action/pause/")
      client.spider.resume(1)
      mock.last_path.should eq("/JSON/spider/action/resume/")
    end
  end

  it "#stop" do
    with_mock_zap do |mock, client|
      client.spider.stop(1)
      mock.last_path.should eq("/JSON/spider/action/stop/")
    end
  end

  it "#stop_all" do
    with_mock_zap do |mock, client|
      client.spider.stop_all
      mock.last_path.should eq("/JSON/spider/action/stopAllScans/")
    end
  end

  it "#exclude_from_scan" do
    with_mock_zap do |mock, client|
      client.spider.exclude_from_scan(".*logout.*")
      mock.last_params["regex"].should eq(".*logout.*")
    end
  end

  it "#set_option_max_depth" do
    with_mock_zap do |mock, client|
      client.spider.set_option_max_depth(5)
      mock.last_params["Integer"].should eq("5")
    end
  end

  it "#full_results" do
    with_mock_zap do |mock, client|
      client.spider.full_results(3)
      mock.last_path.should eq("/JSON/spider/view/fullResults/")
      # scanId is mandatory in ZAP's API; omitting it made the view fail.
      mock.last_params["scanId"].should eq("3")
    end
  end

  it "#add_allowed_resource" do
    with_mock_zap do |mock, client|
      client.spider.add_allowed_resource(".*\\.js", enabled: true)
      mock.last_params["regex"].should eq(".*\\.js")
      mock.last_params["enabled"].should eq("true")
    end
  end
end
