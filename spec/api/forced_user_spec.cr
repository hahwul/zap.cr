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
      client.forced_user.enabled?(1)
      mock.last_path.should eq("/JSON/forcedUser/view/isForcedUserModeEnabled/")
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
      client.forced_user.set_enabled(1, true)
      mock.last_params["boolean"].should eq("true")
    end
  end
end
