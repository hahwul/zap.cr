require "../spec_helper"

describe Zap::Api::Reports do
  it "#templates" do
    with_mock_zap do |mock, client|
      client.reports.templates
      mock.last_path.should eq("/JSON/reports/view/templates/")
    end
  end

  it "#template_details" do
    with_mock_zap do |mock, client|
      client.reports.template_details("traditional-html")
      mock.last_params["template"].should eq("traditional-html")
    end
  end

  it "#generate" do
    with_mock_zap do |mock, client|
      client.reports.generate(
        title: "Scan Report",
        template: "traditional-html",
        sites: "http://example.com",
        report_dir: "/tmp/reports"
      )
      mock.last_path.should eq("/JSON/reports/action/generate/")
      mock.last_params["title"].should eq("Scan Report")
      mock.last_params["template"].should eq("traditional-html")
      mock.last_params["sites"].should eq("http://example.com")
      mock.last_params["reportDir"].should eq("/tmp/reports")
    end
  end

  it "#generate with risk filter" do
    with_mock_zap do |mock, client|
      client.reports.generate(
        title: "High Risk Report",
        template: "traditional-html",
        included_risks: "High,Medium"
      )
      mock.last_params["includedRisks"].should eq("High,Medium")
    end
  end
end
