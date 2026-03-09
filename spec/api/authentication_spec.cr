require "../spec_helper"

describe Zap::Api::Authentication do
  it "#supported_methods" do
    with_mock_zap do |mock, client|
      client.authentication.supported_methods
      mock.last_path.should eq("/JSON/authentication/view/getSupportedAuthenticationMethods/")
    end
  end

  it "#get_method" do
    with_mock_zap do |mock, client|
      client.authentication.get_method(1)
      mock.last_params["contextId"].should eq("1")
    end
  end

  it "#set_method" do
    with_mock_zap do |mock, client|
      client.authentication.set_method(1, "formBasedAuthentication", "loginUrl=http://example.com/login")
      mock.last_params["contextId"].should eq("1")
      mock.last_params["authMethodName"].should eq("formBasedAuthentication")
      mock.last_params["authMethodConfigParams"].should eq("loginUrl=http://example.com/login")
    end
  end

  it "#set_logged_in_indicator" do
    with_mock_zap do |mock, client|
      client.authentication.set_logged_in_indicator(1, "\\QWelcome\\E")
      mock.last_params["loggedInIndicatorRegex"].should eq("\\QWelcome\\E")
    end
  end

  it "#set_logged_out_indicator" do
    with_mock_zap do |mock, client|
      client.authentication.set_logged_out_indicator(1, "\\QLogin\\E")
      mock.last_params["loggedOutIndicatorRegex"].should eq("\\QLogin\\E")
    end
  end
end
