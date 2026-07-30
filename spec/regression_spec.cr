require "./spec_helper"

# Regression specs for bugs found by auditing the client against the ZAP API.
describe "regressions" do
  describe "Client does not mutate caller-supplied params" do
    it "leaves the caller's hash untouched when injecting the API key" do
      with_mock_zap do |_mock, client|
        params = {"url" => "http://example.com"}
        client.request("/JSON/core/view/version/", params)
        params.has_key?("apikey").should be_false
        params.should eq({"url" => "http://example.com"})
      end
    end

    it "still sends the API key on the wire" do
      with_mock_zap do |mock, client|
        client.request("/JSON/core/view/version/", {"url" => "http://example.com"})
        mock.last_params["apikey"].should eq("test-api-key")
      end
    end

    it "does not reuse a stale API key when it changes between calls" do
      with_mock_zap do |mock, client|
        params = {"url" => "http://example.com"}
        client.request("/JSON/core/view/version/", params)
        client.api_key = "rotated"
        client.request("/JSON/core/view/version/", params)
        mock.last_params["apikey"].should eq("rotated")
      end
    end

    it "keeps an explicitly supplied apikey" do
      with_mock_zap do |mock, client|
        client.request("/JSON/core/view/version/", {"apikey" => "explicit"})
        mock.last_params["apikey"].should eq("explicit")
      end
    end

    it "does not mutate the caller's hash in request_other either" do
      with_mock_zap do |_mock, client|
        params = {"fileName" => "report.html"}
        client.request_other("/OTHER/core/other/fileDownload/", params)
        params.has_key?("apikey").should be_false
      end
    end
  end
end
