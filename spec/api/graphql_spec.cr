require "../spec_helper"

describe Zap::Api::Graphql do
  it "#import_url" do
    with_mock_zap do |mock, client|
      client.graphql.import_url("http://example.com/graphql")
      mock.last_path.should eq("/JSON/graphql/action/importUrl/")
      mock.last_params["url"].should eq("http://example.com/graphql")
    end
  end

  it "#import_file" do
    with_mock_zap do |mock, client|
      client.graphql.import_file("/tmp/schema.graphql", endpoint: "http://example.com/graphql")
      mock.last_params["file"].should eq("/tmp/schema.graphql")
      mock.last_params["endurl"].should eq("http://example.com/graphql")
    end
  end

  it "#set_option_max_query_depth" do
    with_mock_zap do |mock, client|
      client.graphql.set_option_max_query_depth(5)
      mock.last_params["Integer"].should eq("5")
    end
  end

  it "#option_max_query_depth" do
    with_mock_zap do |mock, client|
      mock.response_body = %({"MaxQueryDepth": "5"})
      client.graphql.option_max_query_depth
      mock.last_path.should eq("/JSON/graphql/view/optionMaxQueryDepth/")
    end
  end

  it "#set_option_request_method" do
    with_mock_zap do |mock, client|
      client.graphql.set_option_request_method("POST")
      mock.last_params["String"].should eq("POST")
    end
  end

  it "#set_option_query_gen_enabled" do
    with_mock_zap do |mock, client|
      client.graphql.set_option_query_gen_enabled(true)
      mock.last_params["Boolean"].should eq("true")
    end
  end
end
