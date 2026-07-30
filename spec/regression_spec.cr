require "./spec_helper"

# Runs the block with ZAP_URL / ZAP_API_KEY set to the given values (nil
# deletes the variable) and restores the previous environment afterwards.
def with_zap_env(url : String?, key : String?, &)
  prev_url = ENV["ZAP_URL"]?
  prev_key = ENV["ZAP_API_KEY"]?
  begin
    url ? (ENV["ZAP_URL"] = url) : ENV.delete("ZAP_URL")
    key ? (ENV["ZAP_API_KEY"] = key) : ENV.delete("ZAP_API_KEY")
    yield
  ensure
    prev_url ? (ENV["ZAP_URL"] = prev_url) : ENV.delete("ZAP_URL")
    prev_key ? (ENV["ZAP_API_KEY"] = prev_key) : ENV.delete("ZAP_API_KEY")
  end
end

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

    it "custompayloads sends category and payload" do
      with_mock_zap do |mock, client|
        client.custom_payloads.add_custom_payload("sql-injection", "' OR 1=1--")
        mock.last_params["category"].should eq("sql-injection")
        mock.last_params["payload"].should eq("' OR 1=1--")

        client.custom_payloads.enable_custom_payloads("sql-injection")
        mock.last_params["category"].should eq("sql-injection")

        client.custom_payloads.custom_payloads
        mock.last_params.has_key?("category").should be_false
      end
    end

    it "localProxies sends address and port" do
      with_mock_zap do |mock, client|
        client.local_proxies.add_additional_proxy("127.0.0.1", 8090, behind_nat: true)
        mock.last_params["address"].should eq("127.0.0.1")
        mock.last_params["port"].should eq("8090")
        mock.last_params["behindNat"].should eq("true")
        mock.last_params.has_key?("alwaysDecodeZip").should be_false

        client.local_proxies.remove_additional_proxy("127.0.0.1", 8090)
        mock.last_params["port"].should eq("8090")
      end
    end

    it "oast setters send their required options" do
      with_mock_zap do |mock, client|
        client.oast.set_active_scan_service("BOAST")
        mock.last_params["name"].should eq("BOAST")

        client.oast.set_boast_options("odiss.eu", 60)
        mock.last_params["server"].should eq("odiss.eu")
        mock.last_params["pollInSecs"].should eq("60")

        client.oast.set_callback_options("0.0.0.0", "example.com", 9090)
        mock.last_params["localAddress"].should eq("0.0.0.0")
        mock.last_params["remoteAddress"].should eq("example.com")
        mock.last_params["port"].should eq("9090")

        client.oast.set_days_to_keep_records(7)
        mock.last_params["days"].should eq("7")
      end
    end

    it "client add-on report actions send their JSON payload" do
      with_mock_zap do |mock, client|
        client.client.report_event(%({"eventName":"pageLoad"}))
        mock.last_params["eventJson"].should eq(%({"eventName":"pageLoad"}))

        client.client.export_client_map("/tmp/map.yaml")
        mock.last_params["pathYaml"].should eq("/tmp/map.yaml")
      end
    end

    it "pnh sends its identifiers" do
      with_mock_zap do |mock, client|
        client.pnh.start_monitoring("http://example.com")
        mock.last_params["url"].should eq("http://example.com")

        client.pnh.monitor("7", "hello")
        mock.last_params["id"].should eq("7")
        mock.last_params["message"].should eq("hello")
      end
    end
  end

  describe "optional criteria ZAP accepts" do
    it "alertFilter sends the attack/evidence/methods criteria" do
      with_mock_zap do |mock, client|
        client.alert_filter.add_alert_filter(
          1, 10016, Zap::Risk::Low,
          url: ".*\\.css", url_is_regex: true,
          parameter: "q", parameter_is_regex: false,
          attack: "<script>", attack_is_regex: false,
          evidence: "alert(1)", evidence_is_regex: true,
          methods: "GET,POST",
        )
        mock.last_params["contextId"].should eq("1")
        mock.last_params["newLevel"].should eq("1")
        mock.last_params["urlIsRegex"].should eq("true")
        mock.last_params["parameterIsRegex"].should eq("false")
        mock.last_params["attack"].should eq("<script>")
        mock.last_params["evidence"].should eq("alert(1)")
        mock.last_params["evidenceIsRegex"].should eq("true")
        mock.last_params["methods"].should eq("GET,POST")
      end
    end

    it "alertFilter omits an isRegex flag whose criterion was not given" do
      with_mock_zap do |mock, client|
        client.alert_filter.add_global_alert_filter(10016, -1, url: ".*\\.css")
        mock.last_params["urlIsRegex"].should eq("false")
        mock.last_params.has_key?("attackIsRegex").should be_false
        mock.last_params.has_key?("evidenceIsRegex").should be_false
        mock.last_params.has_key?("parameterIsRegex").should be_false
      end
    end

    it "alert alerts filters on falsePositive only when asked" do
      with_mock_zap do |mock, client|
        mock.response_body = %({"alerts": []})
        client.alert.alerts
        mock.last_params.has_key?("falsePositive").should be_false

        client.alert.alerts(false_positive: false)
        mock.last_params["falsePositive"].should eq("false")
      end
    end

    it "openapi imports as a user" do
      with_mock_zap do |mock, client|
        client.openapi.import_url("http://example.com/openapi.json", context_id: 1, user_id: 2)
        mock.last_params["contextId"].should eq("1")
        mock.last_params["userId"].should eq("2")
      end
    end

    it "script load passes a charset" do
      with_mock_zap do |mock, client|
        client.script.load("s", "standalone", "ECMAScript", "/tmp/s.js", charset: "ISO-8859-1")
        mock.last_params["charset"].should eq("ISO-8859-1")
      end
    end

    it "replacer rules can be scoped by url and method" do
      with_mock_zap do |mock, client|
        client.replacer.add_rule("r", true, "REQ_HEADER", false, "Authorization", url: ".*/api/.*", method: "POST")
        mock.last_params["url"].should eq(".*/api/.*")
        mock.last_params["method"].should eq("POST")
      end
    end

    it "ajaxSpider excluded elements accept the matching criteria" do
      with_mock_zap do |mock, client|
        client.ajax_spider.add_excluded_element("ctx", "logout link", "a", xpath: "//a[@id='logout']", text: "Log out")
        mock.last_params["xpath"].should eq("//a[@id='logout']")
        mock.last_params["text"].should eq("Log out")
        mock.last_params.has_key?("attributeName").should be_false
      end
    end
  end

  describe "Scan polling" do
    it "gives up instead of looping forever on a scan that never progresses" do
      with_mock_zap do |mock, client|
        mock.response_handler = ->(path : String, _params : URI::Params) {
          case path
          when "/JSON/ascan/action/scan/" then %({"scan": "0"})
          when "/JSON/ascan/view/status/" then %({"status": "0"})
          else                                 %({"Result": "OK"})
          end
        }

        expect_raises(Zap::Error, /Timed out waiting for active scan/) do
          client.scan.active("http://example.com", poll_interval: 0.seconds, timeout: 20.milliseconds)
        end
      end
    end

    it "does not time out a scan that finishes in budget" do
      with_mock_zap do |mock, client|
        mock.response_handler = ->(path : String, _params : URI::Params) {
          case path
          when "/JSON/ascan/action/scan/"        then %({"scan": "0"})
          when "/JSON/ascan/view/status/"        then %({"status": "100"})
          when "/JSON/alert/view/alertsSummary/" then %({"alertsSummary": {}})
          else                                        %({"Result": "OK"})
          end
        }

        result = client.scan.active("http://example.com", poll_interval: 0.seconds, timeout: 10.seconds)
        result["alertsSummary"].should_not be_nil
      end
    end

    it "reads a float progress value instead of stalling at 0" do
      with_mock_zap do |mock, client|
        polls = 0
        mock.response_handler = ->(path : String, _params : URI::Params) {
          case path
          when "/JSON/ascan/action/scan/"
            %({"scan": "0"})
          when "/JSON/ascan/view/status/"
            polls += 1
            # A JSON number with a fractional part, then a float-ish string.
            polls <= 1 ? %({"status": 42.0}) : %({"status": "100.0"})
          when "/JSON/alert/view/alertsSummary/"
            %({"alertsSummary": {}})
          else
            %({"Result": "OK"})
          end
        }

        progress = [] of Int32
        client.scan.active("http://example.com", poll_interval: 0.seconds) do |_phase, pct|
          progress << pct
        end
        progress.should contain(42)
        progress.should contain(100)
      end
    end

    it "does not crash when the ajax spider reports a non-string status" do
      with_mock_zap do |mock, client|
        mock.response_handler = ->(path : String, _params : URI::Params) {
          case path
          when "/JSON/ajaxSpider/view/status/"      then %({"status": 0})
          when "/JSON/ajaxSpider/view/fullResults/" then %({"fullResults": []})
          else                                           %({"Result": "OK"})
          end
        }

        result = client.scan.ajax_spider("http://example.com", poll_interval: 0.seconds)
        result["fullResults"].should_not be_nil
      end
    end
  end

  describe "base_url path prefix" do
    it "keeps a path prefix from base_url on every request" do
      mock = MockZapServer.new
      port = mock.start
      client = Zap::Client.new("http://127.0.0.1:#{port}/zap", "test-api-key")
      begin
        client.core.version
        mock.last_path.should eq("/zap/JSON/core/view/version/")
      ensure
        client.close
        mock.stop
      end
    end

    it "does not produce a double slash when base_url ends with one" do
      mock = MockZapServer.new
      port = mock.start
      client = Zap::Client.new("http://127.0.0.1:#{port}/zap/", "test-api-key")
      begin
        client.core.version
        mock.last_path.should eq("/zap/JSON/core/view/version/")
      ensure
        client.close
        mock.stop
      end
    end

    it "leaves paths unchanged for a root-mounted daemon" do
      with_mock_zap do |mock, client|
        client.core.version
        mock.last_path.should eq("/JSON/core/view/version/")
      end
    end

    it "applies the prefix to OTHER endpoints and keeps the query string" do
      mock = MockZapServer.new
      port = mock.start
      client = Zap::Client.new("http://127.0.0.1:#{port}/zap", "test-api-key")
      begin
        client.core.message_har("7")
        mock.last_path.should eq("/zap/OTHER/core/other/messageHar/")
        mock.last_params["id"].should eq("7")
        mock.last_params["apikey"].should eq("test-api-key")
      ensure
        client.close
        mock.stop
      end
    end
  end

  describe "explicit constructor args always beat ENV" do
    it "does not let ZAP_URL hijack a base_url that equals the built-in default" do
      with_zap_env("http://someone-elses-zap:9999", nil) do
        client = Zap::Client.new("http://localhost:8080")
        client.base_url.should eq("http://localhost:8080")
      end
    end

    it "does not let ZAP_API_KEY override an explicitly empty api_key" do
      with_zap_env(nil, "env-secret") do
        client = Zap::Client.new("http://localhost:8080", "")
        client.api_key.should eq("")
      end
    end

    it "still falls back to ENV when no arguments are given" do
      with_zap_env("http://env-host:7070", "env-secret") do
        client = Zap::Client.new
        client.base_url.should eq("http://env-host:7070")
        client.api_key.should eq("env-secret")
      end
    end

    it "treats an empty env var as unset" do
      with_zap_env("", "") do
        client = Zap::Client.new
        client.base_url.should eq(Zap::Client::DEFAULT_BASE_URL)
        client.api_key.should eq("")
      end
    end
  end

  describe "alerts are read only after the passive queue drains" do
    it "waits for recordsToScan to reach zero before fetching the summary" do
      with_mock_zap do |mock, client|
        order = [] of String
        records = 3
        mock.response_handler = ->(path : String, _params : URI::Params) {
          case path
          when "/JSON/ascan/action/scan/"
            %({"scan": "0"})
          when "/JSON/ascan/view/status/"
            %({"status": "100"})
          when "/JSON/pscan/view/recordsToScan/"
            order << "pscan"
            records -= 1
            %({"recordsToScan": "#{records}"})
          when "/JSON/alert/view/alertsSummary/"
            order << "summary"
            %({"alertsSummary": {"High": 1}})
          else
            %({"Result": "OK"})
          end
        }

        phases = [] of String
        client.scan.active("http://example.com", poll_interval: 0.seconds) do |phase, _progress|
          phases << phase
        end

        # The summary must come last, after the queue reported zero.
        order.should eq(["pscan", "pscan", "pscan", "summary"])
        phases.should contain("pscan")
      end
    end

    it "reports the pscan phase as 0 then 100" do
      with_mock_zap do |mock, client|
        mock.response_handler = ->(path : String, _params : URI::Params) {
          case path
          when "/JSON/ascan/action/scan/"        then %({"scan": "0"})
          when "/JSON/ascan/view/status/"        then %({"status": "100"})
          when "/JSON/pscan/view/recordsToScan/" then %({"recordsToScan": "0"})
          when "/JSON/alert/view/alertsSummary/" then %({"alertsSummary": {}})
          else                                        %({"Result": "OK"})
          end
        }

        pscan = [] of Int32
        client.scan.active("http://example.com", poll_interval: 0.seconds) do |phase, progress|
          pscan << progress if phase == "pscan"
        end
        pscan.should eq([0, 100])
      end
    end

    it "skips the wait when wait_for_passive is false" do
      with_mock_zap do |mock, client|
        pscan_calls = 0
        mock.response_handler = ->(path : String, _params : URI::Params) {
          case path
          when "/JSON/ascan/action/scan/"
            %({"scan": "0"})
          when "/JSON/ascan/view/status/"
            %({"status": "100"})
          when "/JSON/pscan/view/recordsToScan/"
            pscan_calls += 1
            %({"recordsToScan": "0"})
          when "/JSON/alert/view/alertsSummary/"
            %({"alertsSummary": {}})
          else
            %({"Result": "OK"})
          end
        }

        client.scan.active("http://example.com", poll_interval: 0.seconds, wait_for_passive: false)
        pscan_calls.should eq(0)
      end
    end

    it "applies the workflow timeout to the passive wait too" do
      with_mock_zap do |mock, client|
        mock.response_handler = ->(path : String, _params : URI::Params) {
          case path
          when "/JSON/ascan/action/scan/"        then %({"scan": "0"})
          when "/JSON/ascan/view/status/"        then %({"status": "100"})
          when "/JSON/pscan/view/recordsToScan/" then %({"recordsToScan": "9"}) # never drains
          else                                        %({"Result": "OK"})
          end
        }

        expect_raises(Zap::TimeoutError, /passive scan/) do
          client.scan.active("http://example.com", poll_interval: 1.millisecond, timeout: 20.milliseconds)
        end
      end
    end

    it "leaves spider-only workflows untouched" do
      with_mock_zap do |mock, client|
        pscan_calls = 0
        mock.response_handler = ->(path : String, _params : URI::Params) {
          case path
          when "/JSON/spider/action/scan/"
            %({"scan": "0"})
          when "/JSON/spider/view/status/"
            %({"status": "100"})
          when "/JSON/pscan/view/recordsToScan/"
            pscan_calls += 1
            %({"recordsToScan": "0"})
          else
            %({"Result": "OK"})
          end
        }

        client.scan.spider("http://example.com", poll_interval: 0.seconds)
        pscan_calls.should eq(0)
      end
    end
  end

  describe "a scan timeout is a Zap::TimeoutError" do
    it "is still a Zap::Error, so existing rescues keep working" do
      with_mock_zap do |mock, client|
        mock.response_handler = ->(path : String, _params : URI::Params) {
          case path
          when "/JSON/ascan/action/scan/" then %({"scan": "0"})
          when "/JSON/ascan/view/status/" then %({"status": "42"}) # wedged forever
          else                                 %({"Result": "OK"})
          end
        }

        ex = expect_raises(Zap::Error, /Timed out/) do
          client.scan.active("http://example.com", poll_interval: 1.millisecond, timeout: 20.milliseconds)
        end
        ex.should be_a(Zap::TimeoutError)
      end
    end
  end

  describe "core alert filters accept the same types as Api::Alert" do
    it "accepts a Zap::Risk enum for risk_id" do
      with_mock_zap do |mock, client|
        client.core.alerts(risk_id: Zap::Risk::High)
        mock.last_params["riskId"].should eq("3")

        client.core.number_of_alerts(risk_id: Zap::Risk::Medium)
        mock.last_params["riskId"].should eq("2")
      end
    end

    it "accepts Int32 start / count / risk_id and omits negatives" do
      with_mock_zap do |mock, client|
        client.core.alerts(start: 0, count: 10, risk_id: 1)
        mock.last_params["start"].should eq("0")
        mock.last_params["count"].should eq("10")
        mock.last_params["riskId"].should eq("1")

        client.core.alerts(start: -1, count: -1, risk_id: -1)
        mock.last_params["start"]?.should be_nil
        mock.last_params["count"]?.should be_nil
        mock.last_params["riskId"]?.should be_nil
      end
    end

    it "still accepts the historical String form" do
      with_mock_zap do |mock, client|
        client.core.alerts(base_url: "http://example.com", start: "0", count: "10", risk_id: "3")
        mock.last_params["start"].should eq("0")
        mock.last_params["count"].should eq("10")
        mock.last_params["riskId"].should eq("3")

        client.core.alerts(start: "", count: "", risk_id: "")
        mock.last_params["start"]?.should be_nil
        mock.last_params["count"]?.should be_nil
        mock.last_params["riskId"]?.should be_nil
      end
    end

    it "agrees with Api::Alert on the wire for the same enum" do
      with_mock_zap do |mock, client|
        client.core.number_of_alerts(base_url: "http://example.com", risk_id: Zap::Risk::High)
        core_risk = mock.last_params["riskId"]

        client.alert.number_of_alerts(base_url: "http://example.com", risk_id: Zap::Risk::High)
        mock.last_params["riskId"].should eq(core_risk)
      end
    end
  end
end
