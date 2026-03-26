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
      client.access_control.scan(1)
      mock.last_path.should eq("/JSON/accessControl/action/scan/")
      mock.last_params["contextId"].should eq("1")
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
