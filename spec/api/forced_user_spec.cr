require "../spec_helper"

describe Zap::Api::ForcedUser do
  it "#get" do
    with_mock_zap do |mock, client|
      client.forced_user.get(1)
      mock.last_path.should eq("/JSON/forcedUser/view/getForcedUser/")
      mock.last_params["contextId"].should eq("1")
    end
  end

  it "#enabled?" do
    with_mock_zap do |mock, client|
      client.forced_user.enabled?
      mock.last_path.should eq("/JSON/forcedUser/view/isForcedUserModeEnabled/")
      # Forced-user mode is global; ZAP takes no contextId here.
      mock.last_params.has_key?("contextId").should be_false
    end
  end

  it "#set" do
    with_mock_zap do |mock, client|
      client.forced_user.set(1, 0)
      mock.last_path.should eq("/JSON/forcedUser/action/setForcedUser/")
      mock.last_params["contextId"].should eq("1")
      mock.last_params["userId"].should eq("0")
    end
  end

  it "#set_enabled" do
    with_mock_zap do |mock, client|
      client.forced_user.set_enabled(true)
      mock.last_params["boolean"].should eq("true")
      mock.last_params.has_key?("contextId").should be_false
    end
  end
end
