require "../spec_helper"

describe Zap::Api::Core do
  it "#version" do
    with_mock_zap do |mock, client|
      mock.response_body = %({"version": "2.15.0"})
      result = client.core.version
      result["version"].as_s.should eq("2.15.0")
      mock.last_path.should eq("/JSON/core/view/version/")
      mock.last_params["apikey"].should eq("test-api-key")
    end
  end

  it "#alerts with default params" do
    with_mock_zap do |mock, client|
      mock.response_body = %({"alerts": []})
      client.core.alerts
      mock.last_path.should eq("/JSON/core/view/alerts/")
    end
  end

  it "#alerts with params" do
    with_mock_zap do |mock, client|
      mock.response_body = %({"alerts": []})
      client.core.alerts(base_url: "http://example.com", start: 0, count: 10)
      mock.last_params["baseurl"].should eq("http://example.com")
      mock.last_params["start"].should eq("0")
      mock.last_params["count"].should eq("10")
    end
  end

  it "#alerts_summary" do
    with_mock_zap do |mock, client|
      mock.response_body = %({"alertsSummary": {"High": 0, "Medium": 1, "Low": 2, "Informational": 3}})
      result = client.core.alerts_summary("http://example.com")
      mock.last_params["baseurl"].should eq("http://example.com")
      result["alertsSummary"]["Medium"].as_i.should eq(1)
    end
  end

  it "#new_session" do
    with_mock_zap do |mock, client|
      client.core.new_session("test-session", overwrite: true)
      mock.last_path.should eq("/JSON/core/action/newSession/")
      mock.last_params["name"].should eq("test-session")
      mock.last_params["overwrite"].should eq("true")
    end
  end

  it "#shutdown" do
    with_mock_zap do |mock, client|
      client.core.shutdown
      mock.last_path.should eq("/JSON/core/action/shutdown/")
    end
  end

  it "#home_directory" do
    with_mock_zap do |mock, client|
      mock.response_body = %({"homeDirectory": "/home/zap"})
      result = client.core.home_directory
      result["homeDirectory"].as_s.should eq("/home/zap")
    end
  end

  it "#access_url" do
    with_mock_zap do |mock, client|
      client.core.access_url("http://example.com", follow_redirects: false)
      mock.last_path.should eq("/JSON/core/action/accessUrl/")
      mock.last_params["url"].should eq("http://example.com")
      mock.last_params["followRedirects"].should eq("false")
    end
  end

  it "#generate_root_ca" do
    with_mock_zap do |mock, client|
      client.core.generate_root_ca
      mock.last_path.should eq("/JSON/core/action/generateRootCA/")
    end
  end

  it "#set_option_timeout_in_secs" do
    with_mock_zap do |mock, client|
      client.core.set_option_timeout_in_secs(60)
      mock.last_params["Integer"].should eq("60")
    end
  end

  it "#exclude_from_proxy" do
    with_mock_zap do |mock, client|
      client.core.exclude_from_proxy(".*\\.js")
      mock.last_params["regex"].should eq(".*\\.js")
    end
  end

  it "#message" do
    with_mock_zap do |mock, client|
      mock.response_body = %({"message": {"id": 1}})
      client.core.message(1)
      mock.last_params["id"].should eq("1")
    end
  end

  it "#site_tree" do
    with_mock_zap do |mock, client|
      client.core.site_tree("http://example.com")
      mock.last_path.should eq("/JSON/core/view/getSiteTree/")
      mock.last_params["url"].should eq("http://example.com")
    end
  end
end
