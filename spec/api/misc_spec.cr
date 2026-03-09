require "../spec_helper"

describe Zap::Api::Soap do
  it "#import_url" do
    with_mock_zap do |mock, client|
      client.soap.import_url("http://example.com/service?wsdl")
      mock.last_path.should eq("/JSON/soap/action/importUrl/")
      mock.last_params["url"].should eq("http://example.com/service?wsdl")
    end
  end

  it "#import_file" do
    with_mock_zap do |mock, client|
      client.soap.import_file("/tmp/service.wsdl")
      mock.last_params["file"].should eq("/tmp/service.wsdl")
    end
  end
end

describe Zap::Api::Exim do
  it "#import_urls" do
    with_mock_zap do |mock, client|
      client.exim.import_urls("/tmp/urls.txt")
      mock.last_path.should eq("/JSON/exim/action/importUrls/")
      mock.last_params["filePath"].should eq("/tmp/urls.txt")
    end
  end

  it "#import_har" do
    with_mock_zap do |mock, client|
      client.exim.import_har("/tmp/traffic.har")
      mock.last_path.should eq("/JSON/exim/action/importHar/")
    end
  end

  it "#export_har" do
    with_mock_zap do |mock, client|
      client.exim.export_har(base_url: "http://example.com")
      mock.last_params["baseurl"].should eq("http://example.com")
    end
  end
end

describe Zap::Api::OpenApi do
  it "#import_url" do
    with_mock_zap do |mock, client|
      client.openapi.import_url("http://example.com/openapi.json")
      mock.last_path.should eq("/JSON/openapi/action/importUrl/")
      mock.last_params["url"].should eq("http://example.com/openapi.json")
    end
  end

  it "#import_file with context" do
    with_mock_zap do |mock, client|
      client.openapi.import_file("/tmp/api.yaml", target: "http://example.com", context_id: 1)
      mock.last_params["file"].should eq("/tmp/api.yaml")
      mock.last_params["target"].should eq("http://example.com")
      mock.last_params["contextId"].should eq("1")
    end
  end
end

describe Zap::Api::Script do
  it "#list" do
    with_mock_zap do |mock, client|
      client.script.list
      mock.last_path.should eq("/JSON/script/view/listScripts/")
    end
  end

  it "#load" do
    with_mock_zap do |mock, client|
      client.script.load("test", "standalone", "ECMAScript", "/tmp/test.js", "Test script")
      mock.last_params["scriptName"].should eq("test")
      mock.last_params["scriptType"].should eq("standalone")
      mock.last_params["scriptEngine"].should eq("ECMAScript")
      mock.last_params["fileName"].should eq("/tmp/test.js")
      mock.last_params["scriptDescription"].should eq("Test script")
    end
  end

  it "#run" do
    with_mock_zap do |mock, client|
      client.script.run("test")
      mock.last_params["scriptName"].should eq("test")
    end
  end

  it "#enable and #disable" do
    with_mock_zap do |mock, client|
      client.script.enable("test")
      mock.last_path.should eq("/JSON/script/action/enable/")
      client.script.disable("test")
      mock.last_path.should eq("/JSON/script/action/disable/")
    end
  end
end

describe Zap::Api::Replacer do
  it "#rules" do
    with_mock_zap do |mock, client|
      client.replacer.rules
      mock.last_path.should eq("/JSON/replacer/view/rules/")
    end
  end

  it "#add_rule" do
    with_mock_zap do |mock, client|
      client.replacer.add_rule("Add auth header", true, "REQ_HEADER", false, "Authorization", replacement: "Bearer token123")
      mock.last_params["description"].should eq("Add auth header")
      mock.last_params["matchString"].should eq("Authorization")
      mock.last_params["replacement"].should eq("Bearer token123")
    end
  end
end

describe Zap::Api::Stats do
  it "#stats" do
    with_mock_zap do |mock, client|
      client.stats.stats
      mock.last_path.should eq("/JSON/stats/view/stats/")
    end
  end

  it "#site_stats" do
    with_mock_zap do |mock, client|
      client.stats.site_stats("http://example.com")
      mock.last_params["site"].should eq("http://example.com")
    end
  end
end

describe Zap::Api::SessionManagement do
  it "#supported_methods" do
    with_mock_zap do |mock, client|
      client.session_management.supported_methods
      mock.last_path.should eq("/JSON/sessionManagement/view/getSupportedSessionManagementMethods/")
    end
  end

  it "#set_method" do
    with_mock_zap do |mock, client|
      client.session_management.set_method(1, "cookieBasedSessionManagement")
      mock.last_params["contextId"].should eq("1")
      mock.last_params["methodName"].should eq("cookieBasedSessionManagement")
    end
  end
end

describe Zap::Api::Automation do
  it "#run_plan" do
    with_mock_zap do |mock, client|
      client.automation.run_plan("/tmp/plan.yaml")
      mock.last_path.should eq("/JSON/automation/action/runPlan/")
      mock.last_params["filePath"].should eq("/tmp/plan.yaml")
    end
  end
end

describe Zap::Api::HttpSessions do
  it "#sessions" do
    with_mock_zap do |mock, client|
      client.http_sessions.sessions("http://example.com")
      mock.last_params["site"].should eq("http://example.com")
    end
  end

  it "#create_empty_session" do
    with_mock_zap do |mock, client|
      client.http_sessions.create_empty_session("http://example.com", "sess1")
      mock.last_params["site"].should eq("http://example.com")
      mock.last_params["session"].should eq("sess1")
    end
  end

  it "#set_session_token_value" do
    with_mock_zap do |mock, client|
      client.http_sessions.set_session_token_value("http://example.com", "sess1", "JSESSIONID", "abc123")
      mock.last_params["tokenValue"].should eq("abc123")
    end
  end
end

describe Zap::Api::Websocket do
  it "#channels" do
    with_mock_zap do |mock, client|
      client.websocket.channels
      mock.last_path.should eq("/JSON/websocket/view/channels/")
    end
  end

  it "#send_text_message" do
    with_mock_zap do |mock, client|
      client.websocket.send_text_message(0, true, "hello")
      mock.last_params["channelId"].should eq("0")
      mock.last_params["outgoing"].should eq("true")
      mock.last_params["message"].should eq("hello")
    end
  end
end

describe Zap::Api::AlertFilter do
  it "#add_global_alert_filter" do
    with_mock_zap do |mock, client|
      client.alert_filter.add_global_alert_filter(10016, -1, url: ".*\\.css")
      mock.last_params["ruleId"].should eq("10016")
      mock.last_params["url"].should eq(".*\\.css")
    end
  end
end

describe Zap::Api::Reveal do
  it "#set_reveal_hidden_fields" do
    with_mock_zap do |mock, client|
      client.reveal.set_reveal_hidden_fields(true)
      mock.last_params["Boolean"].should eq("true")
    end
  end
end
