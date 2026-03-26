require "../spec_helper"

describe Zap::Api::Alert do
  it "#get" do
    with_mock_zap do |mock, client|
      mock.response_body = %({"alert": {"id": 1, "name": "XSS", "risk": "High"}})
      result = client.alert.get(1)
      mock.last_params["id"].should eq("1")
      result["alert"]["name"].as_s.should eq("XSS")
    end
  end

  it "#alerts" do
    with_mock_zap do |mock, client|
      mock.response_body = %({"alerts": []})
      client.alert.alerts(base_url: "http://example.com", start: 0, count: 20)
      mock.last_params["baseurl"].should eq("http://example.com")
      mock.last_params["start"].should eq("0")
      mock.last_params["count"].should eq("20")
    end
  end

  it "#alerts_summary" do
    with_mock_zap do |mock, client|
      mock.response_body = %({"alertsSummary": {"High": 1, "Medium": 2, "Low": 3, "Informational": 0}})
      result = client.alert.alerts_summary("http://example.com")
      result["alertsSummary"]["High"].as_i.should eq(1)
    end
  end

  it "#number_of_alerts" do
    with_mock_zap do |mock, client|
      mock.response_body = %({"numberOfAlerts": "6"})
      client.alert.number_of_alerts(base_url: "http://example.com")
      mock.last_path.should eq("/JSON/alert/view/numberOfAlerts/")
    end
  end

  it "#alerts_by_risk" do
    with_mock_zap do |mock, client|
      client.alert.alerts_by_risk(url: "http://example.com")
      mock.last_path.should eq("/JSON/alert/view/alertsByRisk/")
    end
  end

  it "#delete_alert" do
    with_mock_zap do |mock, client|
      client.alert.delete_alert(1)
      mock.last_path.should eq("/JSON/alert/action/deleteAlert/")
      mock.last_params["id"].should eq("1")
    end
  end

  it "#delete_all_alerts" do
    with_mock_zap do |mock, client|
      client.alert.delete_all_alerts
      mock.last_path.should eq("/JSON/alert/action/deleteAllAlerts/")
    end
  end

  it "#update_alerts_confidence" do
    with_mock_zap do |mock, client|
      client.alert.update_alerts_confidence("1,2,3", 2)
      mock.last_params["ids"].should eq("1,2,3")
      mock.last_params["confidenceId"].should eq("2")
    end
  end

  it "#add_alert" do
    with_mock_zap do |mock, client|
      client.alert.add_alert(1, "Test Alert", 3, 2, "A test alert", cwe_id: 79, wasc_id: 8)
      mock.last_path.should eq("/JSON/alert/action/addAlert/")
      mock.last_params["messageId"].should eq("1")
      mock.last_params["name"].should eq("Test Alert")
      mock.last_params["riskId"].should eq("3")
      mock.last_params["confidenceId"].should eq("2")
      mock.last_params["description"].should eq("A test alert")
      mock.last_params["cweId"].should eq("79")
      mock.last_params["wascId"].should eq("8")
    end
  end

  it "#add_alert without optional params" do
    with_mock_zap do |mock, client|
      client.alert.add_alert(1, "Test", 1, 1, "desc")
      mock.last_params.has_key?("cweId").should be_false
      mock.last_params.has_key?("param").should be_false
    end
  end
end
