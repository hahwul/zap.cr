require "./spec_helper"

describe "audited ZAP compatibility" do
  it "keeps an invalid risk out of alert deletion requests" do
    with_mock_zap do |mock, client|
      expect_raises(Zap::Error, /Invalid risk_id/) { client.alert.delete_alerts(risk_id: -2) }
      mock.last_path.should be_empty
      client.alert.delete_alerts(base_url: "https://example.invalid:8443", risk_id: Zap::Risk::High)
      mock.last_params["baseurl"].should eq("https://example.invalid:8443/")
      mock.last_params["riskId"].should eq("3")
    end
  end

  it "requires a directory boundary for URL-scoped alert deletion" do
    with_mock_zap do |mock, client|
      expect_raises(Zap::Error, /directory path/) do
        client.alert.delete_alerts(base_url: "https://example.invalid/api")
      end
      expect_raises(Zap::Error, /query/) do
        client.alert.delete_alerts(base_url: "https://example.invalid/api/?id=1")
      end
      mock.last_path.should be_empty

      client.alert.delete_alerts(base_url: "https://example.invalid/api/")
      mock.last_params["baseurl"].should eq("https://example.invalid/api/")
    end
  end

  it "rejects upload content ZAP cannot store faithfully" do
    with_mock_zap do |mock, client|
      ["", String.new(Bytes[255]), "${XFER}/example"].each do |contents|
        expect_raises(Zap::Error, /File upload/) { client.core.file_upload("test.txt", contents) }
      end
      mock.last_path.should be_empty
    end
  end

  it "redacts credentials when the base URL is malformed" do
    client = Zap::Client.new("http://user:password@localhost:invalid/zap")
    client.inspect.should contain("[INVALID URL]")
    client.inspect.should_not contain("password")
  end

  it "recognizes JSON errors with whitespace and reordered keys" do
    with_mock_zap do |mock, client|
      mock.response_body = %({\n  "message": "Does Not Exist", "code": "does_not_exist"\n})
      expect_raises(Zap::ApiError) { client.core.file_download("missing.txt") }.code.should eq("does_not_exist")
      mock.response_status = 400
      expect_raises(Zap::HttpError) { client.core.version }.code.should eq("does_not_exist")
    end
  end

  it "does not replay a state-changing GET when its response is lost" do
    server = TCPServer.new("127.0.0.1", 0)
    attempts = 0

    spawn do
      while sock = server.accept?
        begin
          while request = HTTP::Request.from_io(sock)
            break unless request.is_a?(HTTP::Request)
            if request.path == "/JSON/core/view/version/"
              body = %({"version":"2.17.0"})
              sock << "HTTP/1.1 200 OK\r\nContent-Length: #{body.bytesize}\r\n\r\n#{body}"
              sock.flush
            else
              attempts += 1
              break
            end
          end
        ensure
          sock.close
        end
      end
    end

    client = Zap::Client.new("http://127.0.0.1:#{server.local_address.port}", "test-key", read_timeout: 1.second)
    begin
      client.core.version["version"].as_s.should eq("2.17.0")
      expect_raises(Zap::Error, /Network error/) { client.context.new_context("test") }
      attempts.should eq(1)
    ensure
      client.close
      server.close
    end
  end

  it "resolves the selected context for the active phase" do
    with_mock_zap do |mock, client|
      active_params = URI::Params.new
      mock.response_handler = ->(path : String, params : URI::Params) do
        case path
        when "/JSON/spider/action/scan/" then %({"scan":"1"})
        when "/JSON/spider/view/status/" then %({"status":"100"})
        when "/JSON/context/view/context/"
          params["contextName"].should eq("restricted")
          %({"context":{"id":"7"}})
        when "/JSON/ascan/action/scan/"
          active_params = params
          %({"scan":"2"})
        when "/JSON/ascan/view/status/" then %({"status":"100"})
        else                                 %({"alertsSummary":{}})
        end
      end

      client.scan.spider_and_scan("http://example.invalid", context_name: "restricted", wait_for_passive: false)
      active_params["contextId"].should eq("7")
    end
  end

  it "prevents the next phase from starting after the deadline" do
    with_mock_zap do |mock, client|
      mock.response_handler = ->(path : String, _params : URI::Params) do
        case path
        when "/JSON/spider/action/scan/" then %({"scan":"1"})
        when "/JSON/spider/view/status/"
          sleep 200.milliseconds
          %({"status":"100"})
        else %({"scan":"2"})
        end
      end

      expect_raises(Zap::TimeoutError, /before starting active scan/) do
        client.scan.spider_and_scan("http://example.invalid", timeout: 100.milliseconds)
      end
      mock.last_path.should eq("/JSON/spider/view/status/")
    end
  end

  it "raises on an invalid passive queue size" do
    with_mock_zap do |mock, client|
      ["unavailable", "0.1"].each do |status|
        mock.response_body = %({"recordsToScan":"#{status}"})
        expect_raises(Zap::Error, /Invalid passive scan queue size/) { client.scan.wait_for_passive_scan }
      end
    end
  end
end
