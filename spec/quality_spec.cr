require "./spec_helper"

describe Zap::Client do
  describe "ENV fallback" do
    it "reads ZAP_URL / ZAP_API_KEY when args are not provided" do
      prev_url = ENV["ZAP_URL"]?
      prev_key = ENV["ZAP_API_KEY"]?
      begin
        ENV["ZAP_URL"] = "http://env-host:7070"
        ENV["ZAP_API_KEY"] = "env-secret"
        client = Zap::Client.new
        client.base_url.should eq("http://env-host:7070")
        client.api_key.should eq("env-secret")
      ensure
        prev_url ? (ENV["ZAP_URL"] = prev_url) : ENV.delete("ZAP_URL")
        prev_key ? (ENV["ZAP_API_KEY"] = prev_key) : ENV.delete("ZAP_API_KEY")
      end
    end

    it "prefers explicit constructor args over ENV" do
      prev_url = ENV["ZAP_URL"]?
      prev_key = ENV["ZAP_API_KEY"]?
      begin
        ENV["ZAP_URL"] = "http://env-host:7070"
        ENV["ZAP_API_KEY"] = "env-secret"
        client = Zap::Client.new("http://explicit:9000", "explicit-key")
        client.base_url.should eq("http://explicit:9000")
        client.api_key.should eq("explicit-key")
      ensure
        prev_url ? (ENV["ZAP_URL"] = prev_url) : ENV.delete("ZAP_URL")
        prev_key ? (ENV["ZAP_API_KEY"] = prev_key) : ENV.delete("ZAP_API_KEY")
      end
    end

    it "keeps defaults when ENV vars are unset" do
      prev_url = ENV["ZAP_URL"]?
      prev_key = ENV["ZAP_API_KEY"]?
      begin
        ENV.delete("ZAP_URL")
        ENV.delete("ZAP_API_KEY")
        client = Zap::Client.new
        client.base_url.should eq("http://localhost:8080")
        client.api_key.should eq("")
      ensure
        prev_url ? (ENV["ZAP_URL"] = prev_url) : nil
        prev_key ? (ENV["ZAP_API_KEY"] = prev_key) : nil
      end
    end

    it "exposes base_url as a read-only getter (not a setter)" do
      client = Zap::Client.new
      client.responds_to?(:base_url=).should be_false
    end
  end

  describe "concurrent requests serialize through the shared client" do
    it "does not corrupt responses when many fibers call at once" do
      # Server echoes the request's `n` param so we can detect interleaving.
      srv = HTTP::Server.new do |ctx|
        n = ctx.request.query_params["n"]? || "?"
        # A tiny yield window widens any race if the mutex were absent.
        Fiber.yield
        ctx.response.content_type = "application/json"
        ctx.response.print %({"n": "#{n}"})
      end
      address = srv.bind_tcp("127.0.0.1", 0)
      spawn { srv.listen }
      Fiber.yield

      client = Zap::Client.new("http://127.0.0.1:#{address.port}")
      results = Channel(String).new
      total = 25
      begin
        total.times do |i|
          spawn do
            res = client.request("/JSON/core/view/version/", {"n" => i.to_s})
            results.send(res["n"].as_s)
          end
        end
        seen = [] of String
        total.times { seen << results.receive }
        seen.sort.should eq((0...total).map(&.to_s).sort!)
      ensure
        client.close
        srv.close
      end
    end
  end
end

describe Zap::Risk do
  it "maps levels to ZAP riskId integers" do
    Zap::Risk::Informational.id.should eq(0)
    Zap::Risk::Low.id.should eq(1)
    Zap::Risk::Medium.id.should eq(2)
    Zap::Risk::High.id.should eq(3)
  end
end

describe Zap::Confidence do
  it "maps levels to ZAP confidenceId integers" do
    Zap::Confidence::FalsePositive.id.should eq(0)
    Zap::Confidence::Low.id.should eq(1)
    Zap::Confidence::Medium.id.should eq(2)
    Zap::Confidence::High.id.should eq(3)
    Zap::Confidence::UserConfirmed.id.should eq(4)
  end
end

describe Zap::Api::Alert do
  describe "enum-aware filtering" do
    it "accepts a Zap::Risk enum in #alerts and sends the right riskId" do
      with_mock_zap do |mock, client|
        mock.response_body = %({"alerts": []})
        client.alert.alerts(base_url: "http://example.com", risk_id: Zap::Risk::High)
        mock.last_params["riskId"].should eq("3")
      end
    end

    it "still accepts a raw Int32 riskId in #alerts" do
      with_mock_zap do |mock, client|
        mock.response_body = %({"alerts": []})
        client.alert.alerts(base_url: "http://example.com", risk_id: 2)
        mock.last_params["riskId"].should eq("2")
      end
    end

    it "accepts Zap::Risk / Zap::Confidence enums in #add_alert" do
      with_mock_zap do |mock, client|
        client.alert.add_alert(1, "Test", Zap::Risk::Medium, Zap::Confidence::UserConfirmed, "desc")
        mock.last_params["riskId"].should eq("2")
        mock.last_params["confidenceId"].should eq("4")
      end
    end

    it "accepts a Zap::Confidence enum in #update_alerts_confidence" do
      with_mock_zap do |mock, client|
        client.alert.update_alerts_confidence("1,2", Zap::Confidence::Low)
        mock.last_params["confidenceId"].should eq("1")
      end
    end

    it "omits riskId when no filter (Int32 -1) is given" do
      with_mock_zap do |mock, client|
        mock.response_body = %({"alerts": []})
        client.alert.alerts(base_url: "http://example.com")
        mock.last_params.has_key?("riskId").should be_false
      end
    end
  end
end
