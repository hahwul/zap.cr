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
end
