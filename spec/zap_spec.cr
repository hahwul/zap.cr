require "./spec_helper"

describe Zap do
  it "has a version" do
    Zap::VERSION.should eq("0.1.0")
  end
end

describe Zap::Client do
  describe "#initialize" do
    it "uses default values" do
      client = Zap::Client.new
      client.base_url.should eq("http://localhost:8080")
      client.api_key.should eq("")
    end

    it "accepts custom values" do
      client = Zap::Client.new("http://zap:9090", "my-api-key")
      client.base_url.should eq("http://zap:9090")
      client.api_key.should eq("my-api-key")
    end
  end

  describe "API component accessors" do
    it "returns correct types for all API modules" do
      client = Zap::Client.new

      client.core.should be_a(Zap::Api::Core)
      client.spider.should be_a(Zap::Api::Spider)
      client.ajax_spider.should be_a(Zap::Api::AjaxSpider)
      client.ascan.should be_a(Zap::Api::Ascan)
      client.pscan.should be_a(Zap::Api::Pscan)
      client.alert.should be_a(Zap::Api::Alert)
      client.alert_filter.should be_a(Zap::Api::AlertFilter)
      client.context.should be_a(Zap::Api::Context)
      client.authentication.should be_a(Zap::Api::Authentication)
      client.authorization.should be_a(Zap::Api::Authorization)
      client.forced_user.should be_a(Zap::Api::ForcedUser)
      client.http_sessions.should be_a(Zap::Api::HttpSessions)
      client.users.should be_a(Zap::Api::Users)
      client.script.should be_a(Zap::Api::Script)
      client.network.should be_a(Zap::Api::Network)
      client.openapi.should be_a(Zap::Api::OpenApi)
      client.stats.should be_a(Zap::Api::Stats)
      client.session_management.should be_a(Zap::Api::SessionManagement)
      client.autoupdate.should be_a(Zap::Api::Autoupdate)
      client.selenium.should be_a(Zap::Api::Selenium)
      client.replacer.should be_a(Zap::Api::Replacer)
      client.reveal.should be_a(Zap::Api::Reveal)
      client.params.should be_a(Zap::Api::Params)
      client.acsrf.should be_a(Zap::Api::Acsrf)
      client.access_control.should be_a(Zap::Api::AccessControl)
      client.automation.should be_a(Zap::Api::Automation)
      client.breakpoints.should be_a(Zap::Api::Breakpoints)
      client.websocket.should be_a(Zap::Api::Websocket)
      client.search.should be_a(Zap::Api::Search)
      client.graphql.should be_a(Zap::Api::Graphql)
      client.soap.should be_a(Zap::Api::Soap)
      client.reports.should be_a(Zap::Api::Reports)
      client.exim.should be_a(Zap::Api::Exim)
    end
  end

  describe "convenience scanning" do
    it "returns Scan instance" do
      client = Zap::Client.new
      client.scan.should be_a(Zap::Scan)
    end
  end
end
