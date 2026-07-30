require "./spec_helper"

# Regression specs for bugs found during the bug-hunting rounds. Each block is
# named after the round that introduced the fix.
describe "regressions" do
  describe "R1: caller-supplied params hash is not mutated" do
    it "does not inject apikey into the hash the caller passed in" do
      with_mock_zap do |mock, client|
        params = {"baseurl" => "http://example.com"}
        client.request("/JSON/core/view/alerts/", params)

        mock.last_params["apikey"]?.should eq("test-api-key")
        params.has_key?("apikey").should be_false
        params.should eq({"baseurl" => "http://example.com"})
      end
    end

    it "does not resend a stale key when a hash is reused after api_key changes" do
      with_mock_zap do |mock, client|
        params = {} of String => String

        client.request("/JSON/core/view/version/", params)
        mock.last_params["apikey"]?.should eq("test-api-key")

        client.api_key = ""
        client.request("/JSON/core/view/version/", params)
        mock.last_params["apikey"]?.should be_nil
      end
    end

    it "leaves an explicit apikey in the caller's params untouched when none is configured" do
      with_mock_zap do |mock, _client|
        client = Zap::Client.new(_client.base_url, "")
        begin
          params = {"apikey" => "caller-supplied"}
          client.request("/JSON/core/view/version/", params)
          mock.last_params["apikey"]?.should eq("caller-supplied")
          params.should eq({"apikey" => "caller-supplied"})
        ensure
          client.close
        end
      end
    end
  end
end
