require "./spec_helper"

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
end
