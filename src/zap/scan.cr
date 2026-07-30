module Zap
  # High-level convenience scanning workflows that combine multiple ZAP API calls.
  #
  # The workflows that return an alerts summary (`full`, `spider_and_scan`,
  # `active`) drain ZAP's passive-scan queue before reading it, and report that
  # as a final `"pscan"` phase to the progress block. Passive rules run
  # asynchronously over the traffic the spider and active scanner generate, so
  # reading the summary the instant the active scan hits 100% returns whatever
  # subset happened to be analysed by then. Pass `wait_for_passive: false` to
  # skip the wait and read the summary immediately.
  class Scan
    POLL_INTERVAL = 5.seconds

    def initialize(@client : Client)
    end

    # Run a full scan: Spider -> Ajax Spider -> Active Scan
    # Returns alerts summary when complete.
    #
    # `timeout` bounds the whole workflow: if the phases have not finished by
    # then, a `Zap::Error` is raised instead of polling forever. It is `nil`
    # (wait indefinitely) by default.
    def full(target : String, context_name : String = "", poll_interval : Time::Span = POLL_INTERVAL, timeout : Time::Span? = nil, wait_for_passive : Bool = true, & : String, Int32 ->) : JSON::Any
      deadline = deadline_for(timeout)

      yield "spider", 0
      spider_id = start_spider(target, context_name)
      wait_for_spider(spider_id, poll_interval, deadline) { |progress| yield "spider", progress }

      yield "ajaxSpider", 0
      start_ajax_spider(target, context_name)
      wait_for_ajax_spider(poll_interval, deadline) { |progress| yield "ajaxSpider", progress }

      yield "ascan", 0
      scan_id = start_active_scan(target)
      wait_for_active_scan(scan_id, poll_interval, deadline) { |progress| yield "ascan", progress }

      if wait_for_passive
        yield "pscan", 0
        drain_passive_scan(poll_interval, deadline) { }
        yield "pscan", 100
      end

      @client.alert.alerts_summary(target)
    end

    def full(target : String, context_name : String = "", poll_interval : Time::Span = POLL_INTERVAL, timeout : Time::Span? = nil, wait_for_passive : Bool = true) : JSON::Any
      full(target, context_name, poll_interval, timeout, wait_for_passive) { |_phase, _progress| }
    end

    # Spider + Active Scan (no Ajax Spider)
    def spider_and_scan(target : String, context_name : String = "", poll_interval : Time::Span = POLL_INTERVAL, timeout : Time::Span? = nil, wait_for_passive : Bool = true, & : String, Int32 ->) : JSON::Any
      deadline = deadline_for(timeout)

      yield "spider", 0
      spider_id = start_spider(target, context_name)
      wait_for_spider(spider_id, poll_interval, deadline) { |progress| yield "spider", progress }

      yield "ascan", 0
      scan_id = start_active_scan(target)
      wait_for_active_scan(scan_id, poll_interval, deadline) { |progress| yield "ascan", progress }

      if wait_for_passive
        yield "pscan", 0
        drain_passive_scan(poll_interval, deadline) { }
        yield "pscan", 100
      end

      @client.alert.alerts_summary(target)
    end

    def spider_and_scan(target : String, context_name : String = "", poll_interval : Time::Span = POLL_INTERVAL, timeout : Time::Span? = nil, wait_for_passive : Bool = true) : JSON::Any
      spider_and_scan(target, context_name, poll_interval, timeout, wait_for_passive) { |_phase, _progress| }
    end

    # Spider only (traditional + ajax)
    def spider_full(target : String, context_name : String = "", poll_interval : Time::Span = POLL_INTERVAL, timeout : Time::Span? = nil, & : String, Int32 ->) : JSON::Any
      deadline = deadline_for(timeout)

      yield "spider", 0
      spider_id = start_spider(target, context_name)
      wait_for_spider(spider_id, poll_interval, deadline) { |progress| yield "spider", progress }

      yield "ajaxSpider", 0
      start_ajax_spider(target, context_name)
      wait_for_ajax_spider(poll_interval, deadline) { |progress| yield "ajaxSpider", progress }

      @client.spider.full_results(spider_id)
    end

    def spider_full(target : String, context_name : String = "", poll_interval : Time::Span = POLL_INTERVAL, timeout : Time::Span? = nil) : JSON::Any
      spider_full(target, context_name, poll_interval, timeout) { |_phase, _progress| }
    end

    # Active Scan only
    def active(target : String, recurse : Bool = true, poll_interval : Time::Span = POLL_INTERVAL, timeout : Time::Span? = nil, wait_for_passive : Bool = true, & : String, Int32 ->) : JSON::Any
      deadline = deadline_for(timeout)

      yield "ascan", 0
      scan_id = start_active_scan(target, recurse)
      wait_for_active_scan(scan_id, poll_interval, deadline) { |progress| yield "ascan", progress }

      if wait_for_passive
        yield "pscan", 0
        drain_passive_scan(poll_interval, deadline) { }
        yield "pscan", 100
      end

      @client.alert.alerts_summary(target)
    end

    def active(target : String, recurse : Bool = true, poll_interval : Time::Span = POLL_INTERVAL, timeout : Time::Span? = nil, wait_for_passive : Bool = true) : JSON::Any
      active(target, recurse, poll_interval, timeout, wait_for_passive) { |_phase, _progress| }
    end

    # Spider only (traditional)
    def spider(target : String, context_name : String = "", poll_interval : Time::Span = POLL_INTERVAL, timeout : Time::Span? = nil, & : String, Int32 ->) : JSON::Any
      deadline = deadline_for(timeout)

      yield "spider", 0
      spider_id = start_spider(target, context_name)
      wait_for_spider(spider_id, poll_interval, deadline) { |progress| yield "spider", progress }

      @client.spider.full_results(spider_id)
    end

    def spider(target : String, context_name : String = "", poll_interval : Time::Span = POLL_INTERVAL, timeout : Time::Span? = nil) : JSON::Any
      spider(target, context_name, poll_interval, timeout) { |_phase, _progress| }
    end

    # Ajax Spider only
    def ajax_spider(target : String, context_name : String = "", poll_interval : Time::Span = POLL_INTERVAL, timeout : Time::Span? = nil, & : String, Int32 ->) : JSON::Any
      deadline = deadline_for(timeout)

      yield "ajaxSpider", 0
      start_ajax_spider(target, context_name)
      wait_for_ajax_spider(poll_interval, deadline) { |progress| yield "ajaxSpider", progress }

      @client.ajax_spider.full_results
    end

    def ajax_spider(target : String, context_name : String = "", poll_interval : Time::Span = POLL_INTERVAL, timeout : Time::Span? = nil) : JSON::Any
      ajax_spider(target, context_name, poll_interval, timeout) { |_phase, _progress| }
    end

    # Wait for passive scan to complete
    def wait_for_passive_scan(poll_interval : Time::Span = POLL_INTERVAL, timeout : Time::Span? = nil, & : Int32 ->)
      drain_passive_scan(poll_interval, deadline_for(timeout)) { |remaining| yield remaining }
    end

    private def drain_passive_scan(poll_interval : Time::Span, deadline : Time::Instant?, & : Int32 ->)
      loop do
        result = @client.pscan.records_to_scan
        remaining = parse_int_field(result, "recordsToScan") || 0
        yield remaining
        break if remaining == 0
        wait_or_timeout(poll_interval, deadline, "passive scan")
      end
    end

    def wait_for_passive_scan(poll_interval : Time::Span = POLL_INTERVAL, timeout : Time::Span? = nil)
      wait_for_passive_scan(poll_interval, timeout) { |_remaining| }
    end

    private def start_spider(target : String, context_name : String = "") : Int32
      # `recurse: true` so a full scan crawls into discovered links rather
      # than only hitting the seed URL.
      result = @client.spider.scan(url: target, context_name: context_name, recurse: true)
      parse_int_field(result, "scan") || raise Zap::Error.new("Failed to start spider: missing scan ID in response")
    end

    private def wait_for_spider(scan_id : Int32, poll_interval : Time::Span, deadline : Time::Instant?, & : Int32 ->)
      loop do
        result = @client.spider.status(scan_id)
        progress = parse_int_field(result, "status") || 0
        yield progress
        break if progress >= 100
        wait_or_timeout(poll_interval, deadline, "spider")
      end
    end

    private def start_ajax_spider(target : String, context_name : String = "")
      @client.ajax_spider.scan(url: target, context_name: context_name)
    end

    private def wait_for_ajax_spider(poll_interval : Time::Span, deadline : Time::Instant?, & : Int32 ->)
      loop do
        result = @client.ajax_spider.status
        status = result["status"]?.try(&.as_s?) || "stopped"
        yield status == "running" ? 50 : 100
        break if status != "running"
        wait_or_timeout(poll_interval, deadline, "ajax spider")
      end
    end

    private def start_active_scan(target : String, recurse : Bool = true) : Int32
      result = @client.ascan.scan(url: target, recurse: recurse)
      parse_int_field(result, "scan") || raise Zap::Error.new("Failed to start active scan: missing scan ID in response")
    end

    private def wait_for_active_scan(scan_id : Int32, poll_interval : Time::Span, deadline : Time::Instant?, & : Int32 ->)
      loop do
        result = @client.ascan.status(scan_id)
        progress = parse_int_field(result, "status") || 0
        yield progress
        break if progress >= 100
        wait_or_timeout(poll_interval, deadline, "active scan")
      end
    end

    # Converts a caller-supplied timeout into a monotonic deadline. Monotonic
    # time is used so a wall-clock adjustment (NTP step, DST) cannot make a
    # long scan appear to have timed out — or hang past its budget.
    private def deadline_for(timeout : Time::Span?) : Time::Instant?
      timeout ? Time.instant + timeout : nil
    end

    # Sleeps until the next poll, unless that would run past `deadline`.
    #
    # Without this every wait loop ran forever: a scan ZAP has forgotten (or
    # one whose status it reports as a value we cannot parse) pins `progress`
    # at 0, and the loop's only exit is `progress >= 100`.
    private def wait_or_timeout(poll_interval : Time::Span, deadline : Time::Instant?, phase : String)
      if deadline && Time.instant + poll_interval > deadline
        raise Zap::TimeoutError.new("Timed out waiting for #{phase} to complete")
      end
      sleep poll_interval
    end

    private def parse_int_field(json : JSON::Any, field : String) : Int32?
      value = json[field]?
      return unless value
      case raw = value.raw
      when Int64
        # `Int64#to_i32` raises OverflowError for values outside the Int32
        # range (e.g. a scan id/value > Int32::MAX). Range-check first and
        # return nil (so callers fall back to `0`) instead of crashing.
        # `Int64#to_i32?` is not available on the Crystal versions CI targets.
        Int32::MIN <= raw <= Int32::MAX ? raw.to_i32 : nil
      when Float64
        # ZAP normally reports progress as a string, but a JSON number with a
        # fractional part (e.g. `100.0`) decodes as Float64. Truncating keeps
        # the wait loops progressing instead of reading every poll as 0.
        Int32::MIN <= raw <= Int32::MAX ? raw.to_i32 : nil
      when String
        # Accept "100" as well as "100.0" / " 100 "; anything else is nil.
        stripped = raw.strip
        stripped.to_i32? || stripped.to_f64?.try do |f|
          Int32::MIN <= f <= Int32::MAX ? f.to_i32 : nil
        end
      end
    end
  end
end
