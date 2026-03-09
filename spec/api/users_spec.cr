require "../spec_helper"

describe Zap::Api::Users do
  it "#list" do
    with_mock_zap do |mock, client|
      client.users.list(1)
      mock.last_path.should eq("/JSON/users/view/usersList/")
      mock.last_params["contextId"].should eq("1")
    end
  end

  it "#new_user" do
    with_mock_zap do |mock, client|
      mock.response_body = %({"userId": "0"})
      result = client.users.new_user(1, "admin")
      mock.last_params["contextId"].should eq("1")
      mock.last_params["name"].should eq("admin")
      result["userId"].as_s.should eq("0")
    end
  end

  it "#set_enabled" do
    with_mock_zap do |mock, client|
      client.users.set_enabled(1, 0, true)
      mock.last_params["enabled"].should eq("true")
    end
  end

  it "#set_auth_credentials" do
    with_mock_zap do |mock, client|
      client.users.set_auth_credentials(1, 0, "username=admin&password=pass")
      mock.last_params["authCredentialsConfigParams"].should eq("username=admin&password=pass")
    end
  end

  it "#remove_user" do
    with_mock_zap do |mock, client|
      client.users.remove_user(1, 0)
      mock.last_path.should eq("/JSON/users/action/removeUser/")
    end
  end
end
