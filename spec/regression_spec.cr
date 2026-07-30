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
end
