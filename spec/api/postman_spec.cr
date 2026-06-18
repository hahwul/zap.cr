require "../spec_helper"

describe Zap::Api::Postman do
  it "#import_file sends the file param" do
    with_mock_zap do |mock, client|
      client.postman.import_file("/tmp/collection.json")
      mock.last_path.should eq("/JSON/postman/action/importFile/")
      mock.last_params["file"].should eq("/tmp/collection.json")
    end
  end

  it "#import_url sends the url param" do
    with_mock_zap do |mock, client|
      client.postman.import_url("http://example.com/collection.json")
      mock.last_path.should eq("/JSON/postman/action/importUrl/")
      mock.last_params["url"].should eq("http://example.com/collection.json")
    end
  end
end
