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

describe Zap::Api::Postman do
  it "#import_file" do
    with_mock_zap do |mock, client|
      client.postman.import_file
      mock.last_path.should eq("/JSON/postman/action/importFile/")
    end
  end

  it "#import_url" do
    with_mock_zap do |mock, client|
      client.postman.import_url
      mock.last_path.should eq("/JSON/postman/action/importUrl/")
    end
  end
end
