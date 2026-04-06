module Zap
  # High-level convenience scanning workflows that combine multiple ZAP API calls.
  class Scan
    POLL_INTERVAL = 5.seconds

    def initialize(@client : Client)
    end

    # Run a full scan: Spider -> Ajax Spider -> Active Scan
    # Returns alerts summary when complete.
    def full(target : String, context_name : String = "", poll_interval : Time::Span = POLL_INTERVAL, &block : String, Int32 ->) : JSON::Any
      yield "spider", 0
      spider_id = start_spider(target, context_name)
      wait_for_spider(spider_id, poll_interval) { |progress| yield "spider", progress }

      yield "ajaxSpider", 0
      start_ajax_spider(target, context_name)
      wait_for_ajax_spider(poll_interval) { |progress| yield "ajaxSpider", progress }

      yield "ascan", 0
      scan_id = start_active_scan(target)
      wait_for_active_scan(scan_id, poll_interval) { |progress| yield "ascan", progress }

      @client.alert.alerts_summary(target)
    end

    def full(target : String, context_name : String = "", poll_interval : Time::Span = POLL_INTERVAL) : JSON::Any
      full(target, context_name, poll_interval) { |_phase, _progress| }
    end

    # Spider + Active Scan (no Ajax Spider)
    def spider_and_scan(target : String, context_name : String = "", poll_interval : Time::Span = POLL_INTERVAL, &block : String, Int32 ->) : JSON::Any
      yield "spider", 0
      spider_id = start_spider(target, context_name)
      wait_for_spider(spider_id, poll_interval) { |progress| yield "spider", progress }

      yield "ascan", 0
      scan_id = start_active_scan(target)
      wait_for_active_scan(scan_id, poll_interval) { |progress| yield "ascan", progress }

      @client.alert.alerts_summary(target)
    end

    def spider_and_scan(target : String, context_name : String = "", poll_interval : Time::Span = POLL_INTERVAL) : JSON::Any
      spider_and_scan(target, context_name, poll_interval) { |_phase, _progress| }
    end

    # Spider only (traditional + ajax)
    def spider_full(target : String, context_name : String = "", poll_interval : Time::Span = POLL_INTERVAL, &block : String, Int32 ->) : JSON::Any
      yield "spider", 0
      spider_id = start_spider(target, context_name)
      wait_for_spider(spider_id, poll_interval) { |progress| yield "spider", progress }

      yield "ajaxSpider", 0
      start_ajax_spider(target, context_name)
      wait_for_ajax_spider(poll_interval) { |progress| yield "ajaxSpider", progress }

      @client.spider.full_results
    end

    def spider_full(target : String, context_name : String = "", poll_interval : Time::Span = POLL_INTERVAL) : JSON::Any
      spider_full(target, context_name, poll_interval) { |_phase, _progress| }
    end

    # Active Scan only
    def active(target : String, recurse : Bool = true, poll_interval : Time::Span = POLL_INTERVAL, &block : String, Int32 ->) : JSON::Any
      yield "ascan", 0
      scan_id = start_active_scan(target, recurse)
      wait_for_active_scan(scan_id, poll_interval) { |progress| yield "ascan", progress }

      @client.alert.alerts_summary(target)
    end

    def active(target : String, recurse : Bool = true, poll_interval : Time::Span = POLL_INTERVAL) : JSON::Any
      active(target, recurse, poll_interval) { |_phase, _progress| }
    end

    # Spider only (traditional)
    def spider(target : String, context_name : String = "", poll_interval : Time::Span = POLL_INTERVAL, &block : String, Int32 ->) : JSON::Any
      yield "spider", 0
      spider_id = start_spider(target, context_name)
      wait_for_spider(spider_id, poll_interval) { |progress| yield "spider", progress }

      @client.spider.full_results
    end

    def spider(target : String, context_name : String = "", poll_interval : Time::Span = POLL_INTERVAL) : JSON::Any
      spider(target, context_name, poll_interval) { |_phase, _progress| }
    end

    # Ajax Spider only
    def ajax_spider(target : String, context_name : String = "", poll_interval : Time::Span = POLL_INTERVAL, &block : String, Int32 ->) : JSON::Any
      yield "ajaxSpider", 0
      start_ajax_spider(target, context_name)
      wait_for_ajax_spider(poll_interval) { |progress| yield "ajaxSpider", progress }

      @client.ajax_spider.full_results
    end

    def ajax_spider(target : String, context_name : String = "", poll_interval : Time::Span = POLL_INTERVAL) : JSON::Any
      ajax_spider(target, context_name, poll_interval) { |_phase, _progress| }
    end

    # Wait for passive scan to complete
    def wait_for_passive_scan(poll_interval : Time::Span = POLL_INTERVAL, &block : Int32 ->)
      loop do
        result = @client.pscan.records_to_scan
        remaining = parse_int_field(result, "recordsToScan") || 0
        yield remaining
        break if remaining == 0
        sleep poll_interval
      end
    end

    def wait_for_passive_scan(poll_interval : Time::Span = POLL_INTERVAL)
      wait_for_passive_scan(poll_interval) { |_remaining| }
    end

    private def start_spider(target : String, context_name : String = "") : Int32
      result = @client.spider.scan(url: target, context_name: context_name)
      parse_int_field(result, "scan") || raise Zap::Error.new("Failed to start spider: missing scan ID in response")
    end

    private def wait_for_spider(scan_id : Int32, poll_interval : Time::Span, &block : Int32 ->)
      loop do
        result = @client.spider.status(scan_id)
        progress = parse_int_field(result, "status") || 0
        yield progress
        break if progress >= 100
        sleep poll_interval
      end
    end

    private def start_ajax_spider(target : String, context_name : String = "")
      @client.ajax_spider.scan(url: target, context_name: context_name)
    end

    private def wait_for_ajax_spider(poll_interval : Time::Span, &block : Int32 ->)
      loop do
        result = @client.ajax_spider.status
        status = result["status"]?.try(&.as_s) || "stopped"
        yield status == "running" ? 50 : 100
        break if status != "running"
        sleep poll_interval
      end
    end

    private def start_active_scan(target : String, recurse : Bool = true) : Int32
      result = @client.ascan.scan(url: target, recurse: recurse)
      parse_int_field(result, "scan") || raise Zap::Error.new("Failed to start active scan: missing scan ID in response")
    end

    private def wait_for_active_scan(scan_id : Int32, poll_interval : Time::Span, &block : Int32 ->)
      loop do
        result = @client.ascan.status(scan_id)
        progress = parse_int_field(result, "status") || 0
        yield progress
        break if progress >= 100
        sleep poll_interval
      end
    end

    private def parse_int_field(json : JSON::Any, field : String) : Int32?
      value = json[field]?
      return nil unless value
      case raw = value.raw
      when Int64
        raw.to_i32
      when String
        raw.to_i32?
      else
        nil
      end
    end
  end
end
