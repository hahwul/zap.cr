require "../spec_helper"

describe Zap::Api::Context do
  it "#new_context" do
    with_mock_zap do |mock, client|
      mock.response_body = %({"contextId": "1"})
      result = client.context.new_context("test-ctx")
      mock.last_path.should eq("/JSON/context/action/newContext/")
      mock.last_params["contextName"].should eq("test-ctx")
      result["contextId"].as_s.should eq("1")
    end
  end

  it "#context_list" do
    with_mock_zap do |mock, client|
      mock.response_body = %({"contextList": ["Default Context", "test-ctx"]})
      result = client.context.context_list
      mock.last_path.should eq("/JSON/context/view/contextList/")
    end
  end

  it "#context" do
    with_mock_zap do |mock, client|
      client.context.context("test-ctx")
      mock.last_params["contextName"].should eq("test-ctx")
    end
  end

  it "#include_in_context" do
    with_mock_zap do |mock, client|
      client.context.include_in_context("test-ctx", "http://example\\.com.*")
      mock.last_params["contextName"].should eq("test-ctx")
      mock.last_params["regex"].should eq("http://example\\.com.*")
    end
  end

  it "#exclude_from_context" do
    with_mock_zap do |mock, client|
      client.context.exclude_from_context("test-ctx", ".*logout.*")
      mock.last_params["regex"].should eq(".*logout.*")
    end
  end

  it "#remove_context" do
    with_mock_zap do |mock, client|
      client.context.remove_context("test-ctx")
      mock.last_path.should eq("/JSON/context/action/removeContext/")
    end
  end

  it "#set_context_in_scope" do
    with_mock_zap do |mock, client|
      client.context.set_context_in_scope("test-ctx", true)
      mock.last_params["booleanInScope"].should eq("true")
    end
  end

  it "#technology_list" do
    with_mock_zap do |mock, client|
      client.context.technology_list
      mock.last_path.should eq("/JSON/context/view/technologyList/")
    end
  end

  it "#export_context" do
    with_mock_zap do |mock, client|
      client.context.export_context("test-ctx", "/tmp/ctx.json")
      mock.last_params["contextFile"].should eq("/tmp/ctx.json")
    end
  end
end
