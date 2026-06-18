require "../spec_helper"

describe Zap::Api::Wappalyzer do
  it "#list_all" do
    with_mock_zap do |mock, client|
      client.wappalyzer.list_all
      mock.last_path.should eq("/JSON/wappalyzer/view/listAll/")
    end
  end

  it "#list_sites" do
    with_mock_zap do |mock, client|
      client.wappalyzer.list_sites
      mock.last_path.should eq("/JSON/wappalyzer/view/listSites/")
    end
  end
end
