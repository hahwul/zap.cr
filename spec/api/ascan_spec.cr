require "../spec_helper"

describe Zap::Api::Ascan do
  it "#scan" do
    with_mock_zap do |mock, client|
      mock.response_body = %({"scan": "0"})
      result = client.ascan.scan(url: "http://example.com")
      mock.last_path.should eq("/JSON/ascan/action/scan/")
      mock.last_params["url"].should eq("http://example.com")
      result["scan"].as_s.should eq("0")
    end
  end

  it "#scan with full options" do
    with_mock_zap do |mock, client|
      mock.response_body = %({"scan": "1"})
      client.ascan.scan(
        url: "http://example.com",
        recurse: false,
        in_scope_only: true,
        scan_policy_name: "custom-policy",
        context_id: 1
      )
      mock.last_params["recurse"].should eq("false")
      mock.last_params["inScopeOnly"].should eq("true")
      mock.last_params["scanPolicyName"].should eq("custom-policy")
      mock.last_params["contextId"].should eq("1")
    end
  end

  it "#scan_as_user" do
    with_mock_zap do |mock, client|
      mock.response_body = %({"scan": "2"})
      client.ascan.scan_as_user("http://example.com", context_id: 1, user_id: 0)
      mock.last_params["url"].should eq("http://example.com")
      mock.last_params["contextId"].should eq("1")
      mock.last_params["userId"].should eq("0")
    end
  end

  it "#status" do
    with_mock_zap do |mock, client|
      mock.response_body = %({"status": "75"})
      result = client.ascan.status(0)
      result["status"].as_s.should eq("75")
    end
  end

  it "#scan_progress" do
    with_mock_zap do |mock, client|
      client.ascan.scan_progress(0)
      mock.last_path.should eq("/JSON/ascan/view/scanProgress/")
    end
  end

  it "#pause and #resume" do
    with_mock_zap do |mock, client|
      client.ascan.pause(0)
      mock.last_path.should eq("/JSON/ascan/action/pause/")
      client.ascan.resume(0)
      mock.last_path.should eq("/JSON/ascan/action/resume/")
    end
  end

  it "#stop" do
    with_mock_zap do |mock, client|
      client.ascan.stop(0)
      mock.last_path.should eq("/JSON/ascan/action/stop/")
    end
  end

  it "#scans" do
    with_mock_zap do |mock, client|
      client.ascan.scans
      mock.last_path.should eq("/JSON/ascan/view/scans/")
    end
  end

  it "#add_scan_policy" do
    with_mock_zap do |mock, client|
      client.ascan.add_scan_policy("test-policy", alert_threshold: "MEDIUM", attack_strength: "HIGH")
      mock.last_params["scanPolicyName"].should eq("test-policy")
      mock.last_params["alertThreshold"].should eq("MEDIUM")
      mock.last_params["attackStrength"].should eq("HIGH")
    end
  end

  it "#set_option_thread_per_host" do
    with_mock_zap do |mock, client|
      client.ascan.set_option_thread_per_host(5)
      mock.last_params["Integer"].should eq("5")
    end
  end

  it "#enable_all_scanners" do
    with_mock_zap do |mock, client|
      client.ascan.enable_all_scanners
      mock.last_path.should eq("/JSON/ascan/action/enableAllScanners/")
    end
  end

  it "#exclude_from_scan" do
    with_mock_zap do |mock, client|
      client.ascan.exclude_from_scan(".*logout.*")
      mock.last_params["regex"].should eq(".*logout.*")
    end
  end
end
