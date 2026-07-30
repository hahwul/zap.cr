require "../spec_helper"

describe Zap::Api::AccessControl do
  it "#scan_status" do
    with_mock_zap do |mock, client|
      client.access_control.scan_status(1)
      mock.last_path.should eq("/JSON/accessControl/view/getScanStatus/")
      mock.last_params["contextId"].should eq("1")
    end
  end

  it "#scan" do
    with_mock_zap do |mock, client|
      client.access_control.scan(1, 2)
      mock.last_path.should eq("/JSON/accessControl/action/scan/")
      mock.last_params["contextId"].should eq("1")
      # ZAP requires the user to scan as.
      mock.last_params["userId"].should eq("2")
      mock.last_params.has_key?("raiseAlert").should be_false
    end
  end

  it "#scan with the optional flags" do
    with_mock_zap do |mock, client|
      client.access_control.scan(1, 2, scan_as_unauth_user: true, raise_alert: false, alert_risk_level: "High")
      mock.last_params["scanAsUnAuthUser"].should eq("true")
      mock.last_params["raiseAlert"].should eq("false")
      mock.last_params["alertRiskLevel"].should eq("High")
    end
  end

  it "#write_html_report" do
    with_mock_zap do |mock, client|
      client.access_control.write_html_report(1, "/tmp/report.html")
      mock.last_params["contextId"].should eq("1")
      mock.last_params["fileName"].should eq("/tmp/report.html")
    end
  end
end
