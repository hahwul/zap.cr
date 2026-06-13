require "./spec_helper"

# Regression specs for stability hardening: malformed input and runtime
# crashes must surface as typed library errors / documented fallbacks rather
# than bare OverflowError / IO::Error / ArgumentError crashes.
describe "stability hardening" do
  describe "F1: parse_int_field Int64 overflow" do
    it "does not raise OverflowError when a scan id exceeds Int32::MAX" do
      with_mock_zap do |mock, client|
        # ZAP returns the scan id as a JSON integer, so `JSON::Any#raw` is an
        # Int64. A value above Int32::MAX previously crashed with OverflowError
        # via `Int64#to_i32`. It must now fall back gracefully: the scan-id
        # path treats the unparseable value as "missing" and raises the typed
        # Zap::Error instead of crashing.
        mock.response_handler = ->(_path : String, _params : URI::Params) {
          %({"scan": 3000000000})
        }

        expect_raises(Zap::Error, /missing scan ID/) do
          client.scan.active("http://example.com", poll_interval: 0.seconds)
        end
      end
    end

    it "defaults oversized Int64 status values to 0 progress instead of crashing" do
      with_mock_zap do |mock, client|
        status_calls = 0
        mock.response_handler = ->(path : String, _params : URI::Params) {
          case path
          when "/JSON/ascan/action/scan/"
            %({"scan": "0"})
          when "/JSON/ascan/view/status/"
            status_calls += 1
            # First poll: an Int64 status above Int32::MAX (would overflow).
            status_calls <= 1 ? %({"status": 3000000000}) : %({"status": "100"})
          when "/JSON/alert/view/alertsSummary/"
            %({"alertsSummary": {}})
          else
            %({"Result": "OK"})
          end
        }

        phases = [] of {String, Int32}
        client.scan.active("http://example.com", poll_interval: 0.seconds) do |phase, progress|
          phases << {phase, progress}
        end

        ascan_progress = phases.select { |p| p[0] == "ascan" }.map(&.[1])
        # Oversized status falls back to 0 (documented default), then 100.
        ascan_progress.should contain(0)
        ascan_progress.should contain(100)
      end
    end
  end

  describe "F2: network errors during a request" do
    it "raises Zap::Error (not IO::Error) when the daemon is unreachable" do
      # Port 1 is reserved and refuses connections, exercising the
      # Socket::ConnectError -> IO::Error path inside perform_request.
      client = Zap::Client.new("http://127.0.0.1:1", "k", connect_timeout: 1.seconds)
      begin
        ex = expect_raises(Zap::Error, /Network error/) do
          client.core.version
        end
        ex.should be_a(Zap::Error)
      ensure
        client.close
      end
    end
  end

  describe "F3: malformed base_url" do
    it "raises Zap::Error (not ArgumentError) on use of a malformed base_url" do
      # "not a valid url" parses as a URI with no scheme, so HTTP::Client.new
      # raises ArgumentError("Missing scheme") on first use. It must surface as
      # the library's typed error instead.
      client = Zap::Client.new("not a valid url", "k")
      begin
        ex = expect_raises(Zap::Error, /Invalid base_url/) do
          client.core.version
        end
        ex.should be_a(Zap::Error)
      ensure
        client.close
      end
    end
  end
end
