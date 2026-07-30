require "./spec_helper"

# Regression specs for bugs found by auditing the client against the ZAP API.
describe "regressions" do
  describe "Client does not mutate caller-supplied params" do
    it "leaves the caller's hash untouched when injecting the API key" do
      with_mock_zap do |_mock, client|
        params = {"url" => "http://example.com"}
        client.request("/JSON/core/view/version/", params)
        params.has_key?("apikey").should be_false
        params.should eq({"url" => "http://example.com"})
      end
    end

    it "still sends the API key on the wire" do
      with_mock_zap do |mock, client|
        client.request("/JSON/core/view/version/", {"url" => "http://example.com"})
        mock.last_params["apikey"].should eq("test-api-key")
      end
    end

    it "does not reuse a stale API key when it changes between calls" do
      with_mock_zap do |mock, client|
        params = {"url" => "http://example.com"}
        client.request("/JSON/core/view/version/", params)
        client.api_key = "rotated"
        client.request("/JSON/core/view/version/", params)
        mock.last_params["apikey"].should eq("rotated")
      end
    end

    it "keeps an explicitly supplied apikey" do
      with_mock_zap do |mock, client|
        client.request("/JSON/core/view/version/", {"apikey" => "explicit"})
        mock.last_params["apikey"].should eq("explicit")
      end
    end

    it "does not mutate the caller's hash in request_other either" do
      with_mock_zap do |_mock, client|
        params = {"fileName" => "report.html"}
        client.request_other("/OTHER/core/other/fileDownload/", params)
        params.has_key?("apikey").should be_false
      end
    end
  end

  describe "Client#close" do
    it "waits for an in-flight request instead of closing the socket underneath it" do
      srv = HTTP::Server.new do |ctx|
        # Widen the window in which a concurrent #close could tear the
        # connection down mid-response.
        Fiber.yield
        ctx.response.content_type = "application/json"
        ctx.response.print %({"version": "2.16.0"})
      end
      address = srv.bind_tcp("127.0.0.1", 0)
      spawn { srv.listen }
      Fiber.yield

      client = Zap::Client.new("http://127.0.0.1:#{address.port}")
      done = Channel(Exception?).new
      begin
        spawn do
          client.core.version
          done.send(nil)
        rescue ex
          done.send(ex)
        end
        Fiber.yield
        client.close
        done.receive.should be_nil
      ensure
        client.close
        srv.close
      end
    end

    it "is idempotent and leaves the client usable" do
      with_mock_zap do |_mock, client|
        client.core.version
        client.close
        client.close
        client.core.version["Result"].should eq("OK")
      end
    end
  end

  describe "ZAP parameter names" do
    it "sends numberOfInstances for core setOptionMaximumAlertInstances" do
      with_mock_zap do |mock, client|
        client.core.set_option_maximum_alert_instances(25)
        mock.last_path.should eq("/JSON/core/action/setOptionMaximumAlertInstances/")
        mock.last_params["numberOfInstances"].should eq("25")
        mock.last_params.has_key?("Integer").should be_false
      end
    end
  end

  describe "endpoints that ZAP requires parameters for" do
    it "ruleConfig sends key (and value)" do
      with_mock_zap do |mock, client|
        client.rule_config.rule_config_value("rules.common.sleep")
        mock.last_params["key"].should eq("rules.common.sleep")

        client.rule_config.reset_rule_config_value("rules.common.sleep")
        mock.last_params["key"].should eq("rules.common.sleep")

        client.rule_config.set_rule_config_value("rules.common.sleep", "5")
        mock.last_params["key"].should eq("rules.common.sleep")
        mock.last_params["value"].should eq("5")
      end
    end

    it "ruleConfig omits an empty value so the setting is cleared" do
      with_mock_zap do |mock, client|
        client.rule_config.set_rule_config_value("rules.common.sleep")
        mock.last_params.has_key?("value").should be_false
      end
    end

    it "retest sends alertIds" do
      with_mock_zap do |mock, client|
        client.retest.retest("1,2,3")
        mock.last_path.should eq("/JSON/retest/action/retest/")
        mock.last_params["alertIds"].should eq("1,2,3")
      end
    end

    it "wappalyzer listSite sends site" do
      with_mock_zap do |mock, client|
        client.wappalyzer.list_site("http://example.com")
        mock.last_params["site"].should eq("http://example.com")
      end
    end

    it "revisit sends site and the time window" do
      with_mock_zap do |mock, client|
        client.revisit.revisit_site_on("http://example.com", "2026-01-01 00:00:00", "2026-01-02 00:00:00")
        mock.last_params["site"].should eq("http://example.com")
        mock.last_params["startTime"].should eq("2026-01-01 00:00:00")
        mock.last_params["endTime"].should eq("2026-01-02 00:00:00")

        client.revisit.revisit_site_off("http://example.com")
        mock.last_params["site"].should eq("http://example.com")
      end
    end
  end
end
