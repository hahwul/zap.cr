require "../spec_helper"

describe Zap::Api::Pscan do
  it "#scanners" do
    with_mock_zap do |mock, client|
      client.pscan.scanners
      mock.last_path.should eq("/JSON/pscan/view/scanners/")
    end
  end

  it "#enable_all_scanners" do
    with_mock_zap do |mock, client|
      client.pscan.enable_all_scanners
      mock.last_path.should eq("/JSON/pscan/action/enableAllScanners/")
    end
  end

  it "#disable_scanners" do
    with_mock_zap do |mock, client|
      client.pscan.disable_scanners("10010,10011")
      mock.last_params["ids"].should eq("10010,10011")
    end
  end

  it "#set_option_scan_only_in_scope" do
    with_mock_zap do |mock, client|
      client.pscan.set_option_scan_only_in_scope(true)
      mock.last_path.should eq("/JSON/pscan/action/setScanOnlyInScope/")
      mock.last_params["onlyInScope"].should eq("true")
    end
  end

  it "#records_to_scan" do
    with_mock_zap do |mock, client|
      mock.response_body = %({"recordsToScan": "0"})
      result = client.pscan.records_to_scan
      result["recordsToScan"].as_s.should eq("0")
    end
  end

  it "reads the body-size limit and sends zero to remove it" do
    with_mock_zap do |mock, client|
      mock.response_body = %({"maxBodySizeInBytes": "1024"})
      client.pscan.max_body_size_in_bytes["maxBodySizeInBytes"].as_s.should eq("1024")
      mock.last_path.should eq("/JSON/pscan/view/maxBodySizeInBytes/")

      client.pscan.set_max_body_size_in_bytes(0)
      mock.last_path.should eq("/JSON/pscan/action/setMaxBodySizeInBytes/")
      mock.last_params["maxSize"].should eq("0")
    end
  end
end
