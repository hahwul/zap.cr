require "../spec_helper"

describe Zap::Api::Network do
  it "#aliases" do
    with_mock_zap do |mock, client|
      client.network.aliases
      mock.last_path.should eq("/JSON/network/view/getAliases/")
    end
  end

  it "#add_alias" do
    with_mock_zap do |mock, client|
      client.network.add_alias("example.com", enabled: true)
      mock.last_params["name"].should eq("example.com")
      mock.last_params["enabled"].should eq("true")
    end
  end

  it "#set_http_proxy" do
    with_mock_zap do |mock, client|
      client.network.set_http_proxy("proxy.local", 8888, username: "user", password: "pass")
      mock.last_method.should eq("POST")
      mock.last_params.to_s.should be_empty
      form = URI::Params.parse(mock.last_body)
      form["host"].should eq("proxy.local")
      form["port"].should eq("8888")
      form["username"].should eq("user")
      form["password"].should eq("pass")
    end
  end

  it "#set_connection_timeout" do
    with_mock_zap do |mock, client|
      client.network.set_connection_timeout(120)
      mock.last_params["timeout"].should eq("120")
    end
  end

  it "#generate_root_ca_cert" do
    with_mock_zap do |mock, client|
      client.network.generate_root_ca_cert
      mock.last_path.should eq("/JSON/network/action/generateRootCaCert/")
    end
  end

  it "#add_local_server" do
    with_mock_zap do |mock, client|
      client.network.add_local_server("0.0.0.0", 8090)
      mock.last_params["address"].should eq("0.0.0.0")
      mock.last_params["port"].should eq("8090")
    end
  end

  it "#set_socks_proxy" do
    with_mock_zap do |mock, client|
      client.network.set_socks_proxy("socks.local", 1080, version: 5)
      mock.last_method.should eq("POST")
      mock.last_params.to_s.should be_empty
      form = URI::Params.parse(mock.last_body)
      form["host"].should eq("socks.local")
      form["version"].should eq("5")
    end
  end
end
