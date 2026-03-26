require "../spec_helper"

describe Zap::Api::Acsrf do
  it "#option_tokens_names" do
    with_mock_zap do |mock, client|
      client.acsrf.option_tokens_names
      mock.last_path.should eq("/JSON/acsrf/view/optionTokensNames/")
    end
  end

  it "#add_option_token" do
    with_mock_zap do |mock, client|
      client.acsrf.add_option_token("csrf_token")
      mock.last_path.should eq("/JSON/acsrf/action/addOptionToken/")
      mock.last_params["String"].should eq("csrf_token")
    end
  end

  it "#remove_option_token" do
    with_mock_zap do |mock, client|
      client.acsrf.remove_option_token("csrf_token")
      mock.last_path.should eq("/JSON/acsrf/action/removeOptionToken/")
      mock.last_params["String"].should eq("csrf_token")
    end
  end

  it "#set_option_partial_matching_enabled" do
    with_mock_zap do |mock, client|
      client.acsrf.set_option_partial_matching_enabled(true)
      mock.last_params["Boolean"].should eq("true")
    end
  end
end
