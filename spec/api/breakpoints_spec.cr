require "../spec_helper"

describe Zap::Api::Breakpoints do
  it "#is_break_all" do
    with_mock_zap do |mock, client|
      client.breakpoints.is_break_all
      mock.last_path.should eq("/JSON/break/view/isBreakAll/")
    end
  end

  it "#brk" do
    with_mock_zap do |mock, client|
      client.breakpoints.brk("http-all", "enabled", "global")
      mock.last_path.should eq("/JSON/break/action/break/")
      mock.last_params["type"].should eq("http-all")
      mock.last_params["state"].should eq("enabled")
      mock.last_params["scope"].should eq("global")
    end
  end

  it "#continue" do
    with_mock_zap do |mock, client|
      client.breakpoints.continue
      mock.last_path.should eq("/JSON/break/action/continue/")
    end
  end

  it "#step" do
    with_mock_zap do |mock, client|
      client.breakpoints.step
      mock.last_path.should eq("/JSON/break/action/step/")
    end
  end

  it "#add_http_breakpoint" do
    with_mock_zap do |mock, client|
      client.breakpoints.add_http_breakpoint("example.com", "url", "contains", false, true)
      mock.last_params["string"].should eq("example.com")
      mock.last_params["location"].should eq("url")
      mock.last_params["inverse"].should eq("false")
      mock.last_params["ignorecase"].should eq("true")
    end
  end
end
