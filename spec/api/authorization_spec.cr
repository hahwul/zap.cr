require "../spec_helper"

describe Zap::Api::Authorization do
  it "#get_method" do
    with_mock_zap do |mock, client|
      client.authorization.get_method(1)
      mock.last_path.should eq("/JSON/authorization/view/getAuthorizationDetectionMethod/")
      mock.last_params["contextId"].should eq("1")
    end
  end

  it "#set_basic_method" do
    with_mock_zap do |mock, client|
      client.authorization.set_basic_method(1, header_regex: "HTTP/1.1 403", body_regex: "Forbidden", status_code: 403)
      mock.last_params["contextId"].should eq("1")
      mock.last_params["headerRegex"].should eq("HTTP/1.1 403")
      mock.last_params["bodyRegex"].should eq("Forbidden")
      mock.last_params["statusCode"].should eq("403")
      mock.last_params["logicalOperator"].should eq("AND")
    end
  end
end
