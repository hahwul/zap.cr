require "../spec_helper"

describe Zap::Api::Autoupdate do
  it "#latest_version_number" do
    with_mock_zap do |mock, client|
      client.autoupdate.latest_version_number
      mock.last_path.should eq("/JSON/autoupdate/view/latestVersionNumber/")
    end
  end

  it "#installed_addons" do
    with_mock_zap do |mock, client|
      client.autoupdate.installed_addons
      mock.last_path.should eq("/JSON/autoupdate/view/installedAddons/")
    end
  end

  it "#install_addon" do
    with_mock_zap do |mock, client|
      client.autoupdate.install_addon("plugnhack")
      mock.last_path.should eq("/JSON/autoupdate/action/installAddon/")
      mock.last_params["id"].should eq("plugnhack")
    end
  end

  it "#uninstall_addon" do
    with_mock_zap do |mock, client|
      client.autoupdate.uninstall_addon("plugnhack")
      mock.last_params["id"].should eq("plugnhack")
    end
  end

  it "#set_option_check_on_start" do
    with_mock_zap do |mock, client|
      client.autoupdate.set_option_check_on_start(false)
      mock.last_params["Boolean"].should eq("false")
    end
  end
end
