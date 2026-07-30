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

# Regression specs for bugs found during the bug-hunting rounds. Each block is
# named after the round that introduced the fix.
describe "regressions" do
  describe "R1: caller-supplied params hash is not mutated" do
    it "does not inject apikey into the hash the caller passed in" do
      with_mock_zap do |mock, client|
        params = {"baseurl" => "http://example.com"}
        client.request("/JSON/core/view/alerts/", params)

        mock.last_params["apikey"]?.should eq("test-api-key")
        params.has_key?("apikey").should be_false
        params.should eq({"baseurl" => "http://example.com"})
      end
    end

    it "does not resend a stale key when a hash is reused after api_key changes" do
      with_mock_zap do |mock, client|
        params = {} of String => String

        client.request("/JSON/core/view/version/", params)
        mock.last_params["apikey"]?.should eq("test-api-key")

        client.api_key = ""
        client.request("/JSON/core/view/version/", params)
        mock.last_params["apikey"]?.should be_nil
      end
    end

    it "leaves an explicit apikey in the caller's params untouched when none is configured" do
      with_mock_zap do |mock, _client|
        client = Zap::Client.new(_client.base_url, "")
        begin
          params = {"apikey" => "caller-supplied"}
          client.request("/JSON/core/view/version/", params)
          mock.last_params["apikey"]?.should eq("caller-supplied")
          params.should eq({"apikey" => "caller-supplied"})
        ensure
          client.close
        end
      end
    end
  end

  describe "R2: ajax spider status is not a JSON string" do
    it "falls back to stopped when status is null instead of raising TypeCastError" do
      with_mock_zap do |mock, client|
        # ZAP's ajaxSpider status view answers `null` when the spider has never
        # been started in the current session. `as_s` raised TypeCastError on
        # that, crashing the poll loop.
        mock.response_handler = ->(path : String, _params : URI::Params) {
          path == "/JSON/ajaxSpider/view/status/" ? %({"status": null}) : %({"Result": "OK"})
        }

        progress = [] of Int32
        client.scan.ajax_spider("http://example.com", poll_interval: 0.seconds) do |_phase, value|
          progress << value
        end
        progress.should contain(100)
      end
    end

    it "falls back to stopped when status is a JSON number" do
      with_mock_zap do |mock, client|
        mock.response_handler = ->(path : String, _params : URI::Params) {
          path == "/JSON/ajaxSpider/view/status/" ? %({"status": 42}) : %({"Result": "OK"})
        }

        progress = [] of Int32
        client.scan.ajax_spider("http://example.com", poll_interval: 0.seconds) do |_phase, value|
          progress << value
        end
        progress.should contain(100)
      end
    end

    it "still polls while the status string is running" do
      with_mock_zap do |mock, client|
        calls = 0
        mock.response_handler = ->(path : String, _params : URI::Params) {
          if path == "/JSON/ajaxSpider/view/status/"
            calls += 1
            calls <= 2 ? %({"status": "running"}) : %({"status": "stopped"})
          else
            %({"Result": "OK"})
          end
        }

        progress = [] of Int32
        client.scan.ajax_spider("http://example.com", poll_interval: 0.seconds) do |_phase, value|
          progress << value
        end
        progress.should contain(50)
        progress.last.should eq(100)
        calls.should eq(3)
      end
    end
  end

  describe "R3: base_url path prefix" do
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

  describe "R4: explicit constructor args always beat ENV" do
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

  describe "R5: close is serialized against in-flight requests" do
    it "waits for a request that is already on the wire" do
      arrived = Channel(Nil).new
      release = Channel(Nil).new
      srv = HTTP::Server.new do |ctx|
        arrived.send(nil)
        release.receive
        ctx.response.print %({"Result": "OK"})
      end
      address = srv.bind_tcp("127.0.0.1", 0)
      spawn { srv.listen }
      Fiber.yield

      client = Zap::Client.new("http://127.0.0.1:#{address.port}", "k")
      order = [] of String
      done = Channel(Nil).new

      begin
        spawn do
          client.core.version
          order << "request"
          done.send(nil)
        end
        # The handler only signals once the request is fully on the wire, so
        # the requesting fiber is provably inside perform_request from here.
        arrived.receive

        spawn do
          client.close
          order << "close"
          done.send(nil)
        end
        Fiber.yield

        release.send(nil)
        2.times { done.receive }

        # Without the lock, close ran immediately and tore down the socket
        # while the response was still being read.
        order.should eq(["request", "close"])
      ensure
        client.close
        srv.close
      end
    end

    it "reopens transparently after a close and tolerates a double close" do
      with_mock_zap do |_mock, client|
        client.core.version
        client.close
        client.close
        client.core.version["Result"].should eq("OK")
      end
    end
  end

  describe "R6: scan workflows can be bounded by a timeout" do
    it "raises Zap::TimeoutError when an active scan never reaches 100%" do
      with_mock_zap do |mock, client|
        mock.response_handler = ->(path : String, _params : URI::Params) {
          case path
          when "/JSON/ascan/action/scan/" then %({"scan": "0"})
          when "/JSON/ascan/view/status/" then %({"status": "42"}) # wedged forever
          else                                 %({"Result": "OK"})
          end
        }

        expect_raises(Zap::TimeoutError, /ascan/) do
          client.scan.active("http://example.com", poll_interval: 1.millisecond, timeout: 20.milliseconds)
        end
      end
    end

    it "raises Zap::TimeoutError when the ajax spider never stops" do
      with_mock_zap do |mock, client|
        mock.response_handler = ->(path : String, _params : URI::Params) {
          path == "/JSON/ajaxSpider/view/status/" ? %({"status": "running"}) : %({"Result": "OK"})
        }

        expect_raises(Zap::TimeoutError, /ajaxSpider/) do
          client.scan.ajax_spider("http://example.com", poll_interval: 1.millisecond, timeout: 20.milliseconds)
        end
      end
    end

    it "raises Zap::TimeoutError when the passive scan queue never drains" do
      with_mock_zap do |mock, client|
        mock.response_handler = ->(_path : String, _params : URI::Params) {
          %({"recordsToScan": "7"})
        }

        expect_raises(Zap::TimeoutError, /pscan/) do
          client.scan.wait_for_passive_scan(poll_interval: 1.millisecond, timeout: 20.milliseconds)
        end
      end
    end

    it "reports a TimeoutError as a Zap::Error so existing rescues still catch it" do
      Zap::TimeoutError.new("x").should be_a(Zap::Error)
    end

    it "does not time out a scan that completes within the budget" do
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

    it "still waits indefinitely when no timeout is given" do
      with_mock_zap do |mock, client|
        polls = 0
        mock.response_handler = ->(path : String, _params : URI::Params) {
          case path
          when "/JSON/ascan/action/scan/"
            %({"scan": "0"})
          when "/JSON/ascan/view/status/"
            polls += 1
            polls < 5 ? %({"status": "10"}) : %({"status": "100"})
          when "/JSON/alert/view/alertsSummary/"
            %({"alertsSummary": {}})
          else
            %({"Result": "OK"})
          end
        }

        client.scan.active("http://example.com", poll_interval: 0.seconds)
        polls.should eq(5)
      end
    end
  end

  describe "R7: alerts are read only after the passive queue drains" do
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

        expect_raises(Zap::TimeoutError, /pscan/) do
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

  describe "R8: core alert filters accept the same types as Api::Alert" do
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

  describe "R10: spider fullResults carries the mandatory scanId" do
    it "passes the spider's own scan id through from Scan#spider" do
      with_mock_zap do |mock, client|
        seen_scan_id = nil.as(String?)
        mock.response_handler = ->(path : String, params : URI::Params) {
          case path
          when "/JSON/spider/action/scan/"
            %({"scan": "12"})
          when "/JSON/spider/view/status/"
            %({"status": "100"})
          when "/JSON/spider/view/fullResults/"
            seen_scan_id = params["scanId"]?
            %({"fullResults": []})
          else
            %({"Result": "OK"})
          end
        }

        client.scan.spider("http://example.com", poll_interval: 0.seconds)
        seen_scan_id.should eq("12")
      end
    end

    it "passes the spider's scan id through from Scan#spider_full" do
      with_mock_zap do |mock, client|
        seen_scan_id = nil.as(String?)
        mock.response_handler = ->(path : String, params : URI::Params) {
          case path
          when "/JSON/spider/action/scan/"
            %({"scan": "34"})
          when "/JSON/spider/view/status/"
            %({"status": "100"})
          when "/JSON/ajaxSpider/view/status/"
            %({"status": "stopped"})
          when "/JSON/spider/view/fullResults/"
            seen_scan_id = params["scanId"]?
            %({"fullResults": []})
          else
            %({"Result": "OK"})
          end
        }

        client.scan.spider_full("http://example.com", poll_interval: 0.seconds)
        seen_scan_id.should eq("34")
      end
    end
  end
end
