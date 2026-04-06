require "./spec_helper"

describe Zap::Scan do
  describe "spider workflow" do
    it "#spider polls until complete" do
      with_mock_zap do |mock, client|
        call_count = 0
        mock.response_handler = ->(path : String, params : URI::Params) {
          call_count += 1
          case path
          when "/JSON/spider/action/scan/"
            %({"scan": "1"})
          when "/JSON/spider/view/status/"
            call_count <= 2 ? %({"status": "50"}) : %({"status": "100"})
          when "/JSON/spider/view/fullResults/"
            %({"fullResults": []})
          else
            %({"Result": "OK"})
          end
        }

        phases = [] of {String, Int32}
        result = client.scan.spider("http://example.com", poll_interval: 0.seconds) do |phase, progress|
          phases << {phase, progress}
        end

        phases.first.should eq({"spider", 0})
        phases.any? { |p| p[0] == "spider" && p[1] == 100 }.should be_true
      end
    end
  end

  describe "active scan workflow" do
    it "#active polls until complete" do
      with_mock_zap do |mock, client|
        call_count = 0
        mock.response_handler = ->(path : String, params : URI::Params) {
          call_count += 1
          case path
          when "/JSON/ascan/action/scan/"
            %({"scan": "0"})
          when "/JSON/ascan/view/status/"
            call_count <= 2 ? %({"status": "50"}) : %({"status": "100"})
          when "/JSON/alert/view/alertsSummary/"
            %({"alertsSummary": {"High": 0, "Medium": 1, "Low": 2}})
          else
            %({"Result": "OK"})
          end
        }

        phases = [] of {String, Int32}
        result = client.scan.active("http://example.com", poll_interval: 0.seconds) do |phase, progress|
          phases << {phase, progress}
        end

        phases.first.should eq({"ascan", 0})
        result["alertsSummary"].should_not be_nil
      end
    end
  end

  describe "error handling" do
    it "raises error when spider scan ID is missing" do
      with_mock_zap do |mock, client|
        mock.response_handler = ->(path : String, params : URI::Params) {
          %({"error": "no scan"})
        }

        expect_raises(Zap::Error, /missing scan ID/) do
          client.scan.spider("http://example.com")
        end
      end
    end

    it "raises error when active scan ID is missing" do
      with_mock_zap do |mock, client|
        mock.response_handler = ->(path : String, params : URI::Params) {
          %({"error": "no scan"})
        }

        expect_raises(Zap::Error, /missing scan ID/) do
          client.scan.active("http://example.com")
        end
      end
    end
  end

  describe "without block" do
    it "#spider works without block" do
      with_mock_zap do |mock, client|
        mock.response_handler = ->(path : String, params : URI::Params) {
          case path
          when "/JSON/spider/action/scan/"
            %({"scan": "1"})
          when "/JSON/spider/view/status/"
            %({"status": "100"})
          when "/JSON/spider/view/fullResults/"
            %({"fullResults": []})
          else
            %({"Result": "OK"})
          end
        }

        result = client.scan.spider("http://example.com", poll_interval: 0.seconds)
        result["fullResults"].should_not be_nil
      end
    end

    it "#active works without block" do
      with_mock_zap do |mock, client|
        mock.response_handler = ->(path : String, params : URI::Params) {
          case path
          when "/JSON/ascan/action/scan/"
            %({"scan": "0"})
          when "/JSON/ascan/view/status/"
            %({"status": "100"})
          when "/JSON/alert/view/alertsSummary/"
            %({"alertsSummary": {}})
          else
            %({"Result": "OK"})
          end
        }

        result = client.scan.active("http://example.com", poll_interval: 0.seconds)
        result["alertsSummary"].should_not be_nil
      end
    end
  end

  describe "full scan workflow" do
    it "#full runs spider, ajax spider, and active scan" do
      with_mock_zap do |mock, client|
        call_count = 0
        mock.response_handler = ->(path : String, params : URI::Params) {
          call_count += 1
          case path
          when "/JSON/spider/action/scan/"
            %({"scan": "1"})
          when "/JSON/spider/view/status/"
            %({"status": "100"})
          when "/JSON/ajaxSpider/action/scan/"
            %({"Result": "OK"})
          when "/JSON/ajaxSpider/view/status/"
            %({"status": "stopped"})
          when "/JSON/ascan/action/scan/"
            %({"scan": "0"})
          when "/JSON/ascan/view/status/"
            %({"status": "100"})
          when "/JSON/alert/view/alertsSummary/"
            %({"alertsSummary": {"High": 1, "Medium": 2, "Low": 3}})
          else
            %({"Result": "OK"})
          end
        }

        phases = [] of {String, Int32}
        result = client.scan.full("http://example.com", poll_interval: 0.seconds) do |phase, progress|
          phases << {phase, progress}
        end

        phase_names = phases.map(&.[0]).uniq
        phase_names.should contain("spider")
        phase_names.should contain("ajaxSpider")
        phase_names.should contain("ascan")
        result["alertsSummary"].should_not be_nil
      end
    end
  end

  describe "spider_and_scan workflow" do
    it "#spider_and_scan runs spider and active scan without ajax spider" do
      with_mock_zap do |mock, client|
        mock.response_handler = ->(path : String, params : URI::Params) {
          case path
          when "/JSON/spider/action/scan/"
            %({"scan": "1"})
          when "/JSON/spider/view/status/"
            %({"status": "100"})
          when "/JSON/ascan/action/scan/"
            %({"scan": "0"})
          when "/JSON/ascan/view/status/"
            %({"status": "100"})
          when "/JSON/alert/view/alertsSummary/"
            %({"alertsSummary": {}})
          else
            %({"Result": "OK"})
          end
        }

        phases = [] of {String, Int32}
        result = client.scan.spider_and_scan("http://example.com", poll_interval: 0.seconds) do |phase, progress|
          phases << {phase, progress}
        end

        phase_names = phases.map(&.[0]).uniq
        phase_names.should contain("spider")
        phase_names.should contain("ascan")
        phase_names.should_not contain("ajaxSpider")
        result["alertsSummary"].should_not be_nil
      end
    end
  end

  describe "ajax spider workflow" do
    it "#ajax_spider polls until stopped" do
      with_mock_zap do |mock, client|
        call_count = 0
        mock.response_handler = ->(path : String, params : URI::Params) {
          call_count += 1
          case path
          when "/JSON/ajaxSpider/action/scan/"
            %({"Result": "OK"})
          when "/JSON/ajaxSpider/view/status/"
            call_count <= 2 ? %({"status": "running"}) : %({"status": "stopped"})
          when "/JSON/ajaxSpider/view/fullResults/"
            %({"fullResults": []})
          else
            %({"Result": "OK"})
          end
        }

        phases = [] of {String, Int32}
        result = client.scan.ajax_spider("http://example.com", poll_interval: 0.seconds) do |phase, progress|
          phases << {phase, progress}
        end

        phases.first.should eq({"ajaxSpider", 0})
        phases.any? { |p| p[1] == 50 }.should be_true
        phases.last[1].should eq(100)
      end
    end
  end

  describe "spider_full workflow" do
    it "#spider_full runs traditional and ajax spider" do
      with_mock_zap do |mock, client|
        mock.response_handler = ->(path : String, params : URI::Params) {
          case path
          when "/JSON/spider/action/scan/"
            %({"scan": "1"})
          when "/JSON/spider/view/status/"
            %({"status": "100"})
          when "/JSON/ajaxSpider/action/scan/"
            %({"Result": "OK"})
          when "/JSON/ajaxSpider/view/status/"
            %({"status": "stopped"})
          when "/JSON/spider/view/fullResults/"
            %({"fullResults": ["http://example.com/page1"]})
          else
            %({"Result": "OK"})
          end
        }

        result = client.scan.spider_full("http://example.com", poll_interval: 0.seconds)
        result["fullResults"].should_not be_nil
      end
    end
  end

  describe "non-numeric status handling" do
    it "defaults to 0 progress on non-numeric spider status" do
      with_mock_zap do |mock, client|
        status_calls = 0
        mock.response_handler = ->(path : String, params : URI::Params) {
          case path
          when "/JSON/spider/action/scan/"
            %({"scan": "1"})
          when "/JSON/spider/view/status/"
            status_calls += 1
            status_calls <= 1 ? %({"status": "not-a-number"}) : %({"status": "100"})
          when "/JSON/spider/view/fullResults/"
            %({"fullResults": []})
          else
            %({"Result": "OK"})
          end
        }

        phases = [] of {String, Int32}
        client.scan.spider("http://example.com", poll_interval: 0.seconds) do |phase, progress|
          phases << {phase, progress}
        end

        # First poll yields 0 (non-numeric fallback), then 100
        spider_progress = phases.select { |p| p[0] == "spider" }.map(&.[1])
        spider_progress.should contain(0)
        spider_progress.should contain(100)
      end
    end

    it "defaults to 0 progress on missing status field" do
      with_mock_zap do |mock, client|
        status_calls = 0
        mock.response_handler = ->(path : String, params : URI::Params) {
          case path
          when "/JSON/ascan/action/scan/"
            %({"scan": "0"})
          when "/JSON/ascan/view/status/"
            status_calls += 1
            status_calls <= 1 ? %({"other": "field"}) : %({"status": "100"})
          when "/JSON/alert/view/alertsSummary/"
            %({"alertsSummary": {}})
          else
            %({"Result": "OK"})
          end
        }

        phases = [] of {String, Int32}
        client.scan.active("http://example.com", poll_interval: 0.seconds) do |phase, progress|
          phases << {phase, progress}
        end

        ascan_progress = phases.select { |p| p[0] == "ascan" }.map(&.[1])
        ascan_progress.should contain(0)
      end
    end
  end
end
