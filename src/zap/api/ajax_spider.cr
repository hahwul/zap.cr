module Zap
  module Api
    class AjaxSpider
      def initialize(@client : Zap::Client)
      end

      # Actions
      def scan(url : String = "", in_scope : Bool = false, context_name : String = "", subtree_only : Bool = false) : JSON::Any
        params = {} of String => String
        params["url"] = url unless url.empty?
        params["inScope"] = in_scope.to_s
        params["contextName"] = context_name unless context_name.empty?
        params["subtreeOnly"] = subtree_only.to_s
        @client.request("/JSON/ajaxSpider/action/scan/", params)
      end

      def scan_as_user(context_name : String, user_name : String, url : String = "", subtree_only : Bool = false) : JSON::Any
        params = {"contextName" => context_name, "userName" => user_name}
        params["url"] = url unless url.empty?
        params["subtreeOnly"] = subtree_only.to_s
        @client.request("/JSON/ajaxSpider/action/scanAsUser/", params)
      end

      def stop : JSON::Any
        @client.request("/JSON/ajaxSpider/action/stop/")
      end

      def add_allowed_resource(regex : String, enabled : Bool = true) : JSON::Any
        @client.request("/JSON/ajaxSpider/action/addAllowedResource/", {"regex" => regex, "enabled" => enabled.to_s})
      end

      def remove_allowed_resource(regex : String) : JSON::Any
        @client.request("/JSON/ajaxSpider/action/removeAllowedResource/", {"regex" => regex})
      end

      def set_enabled_allowed_resource(regex : String, enabled : Bool) : JSON::Any
        @client.request("/JSON/ajaxSpider/action/setEnabledAllowedResource/", {"regex" => regex, "enabled" => enabled.to_s})
      end

      def add_excluded_element(context_name : String, description : String, element : String) : JSON::Any
        @client.request("/JSON/ajaxSpider/action/addExcludedElement/", {
          "contextName" => context_name, "description" => description, "element" => element,
        })
      end

      def remove_excluded_element(context_name : String, description : String) : JSON::Any
        @client.request("/JSON/ajaxSpider/action/removeExcludedElement/", {
          "contextName" => context_name, "description" => description,
        })
      end

      def set_option_browser_id(browser : String) : JSON::Any
        @client.request("/JSON/ajaxSpider/action/setOptionBrowserId/", {"String" => browser})
      end

      def set_option_max_crawl_depth(depth : Int32) : JSON::Any
        @client.request("/JSON/ajaxSpider/action/setOptionMaxCrawlDepth/", {"Integer" => depth.to_s})
      end

      def set_option_max_crawl_states(states : Int32) : JSON::Any
        @client.request("/JSON/ajaxSpider/action/setOptionMaxCrawlStates/", {"Integer" => states.to_s})
      end

      def set_option_max_duration(minutes : Int32) : JSON::Any
        @client.request("/JSON/ajaxSpider/action/setOptionMaxDuration/", {"Integer" => minutes.to_s})
      end

      def set_option_number_of_browsers(num : Int32) : JSON::Any
        @client.request("/JSON/ajaxSpider/action/setOptionNumberOfBrowsers/", {"Integer" => num.to_s})
      end

      def set_option_click_default_elems(enabled : Bool) : JSON::Any
        @client.request("/JSON/ajaxSpider/action/setOptionClickDefaultElems/", {"Boolean" => enabled.to_s})
      end

      def set_option_click_elems_once(enabled : Bool) : JSON::Any
        @client.request("/JSON/ajaxSpider/action/setOptionClickElemsOnce/", {"Boolean" => enabled.to_s})
      end

      def set_option_event_wait(millis : Int32) : JSON::Any
        @client.request("/JSON/ajaxSpider/action/setOptionEventWait/", {"Integer" => millis.to_s})
      end

      def set_option_reload_wait(millis : Int32) : JSON::Any
        @client.request("/JSON/ajaxSpider/action/setOptionReloadWait/", {"Integer" => millis.to_s})
      end

      def set_option_random_inputs(enabled : Bool) : JSON::Any
        @client.request("/JSON/ajaxSpider/action/setOptionRandomInputs/", {"Boolean" => enabled.to_s})
      end

      # Views
      def status : JSON::Any
        @client.request("/JSON/ajaxSpider/view/status/")
      end

      def results(start : Int32 = -1, count : Int32 = -1) : JSON::Any
        params = {} of String => String
        params["start"] = start.to_s if start >= 0
        params["count"] = count.to_s if count >= 0
        @client.request("/JSON/ajaxSpider/view/results/", params)
      end

      def full_results : JSON::Any
        @client.request("/JSON/ajaxSpider/view/fullResults/")
      end

      def number_of_results : JSON::Any
        @client.request("/JSON/ajaxSpider/view/numberOfResults/")
      end

      def allowed_resources : JSON::Any
        @client.request("/JSON/ajaxSpider/view/allowedResources/")
      end

      def option_browser_id : JSON::Any
        @client.request("/JSON/ajaxSpider/view/optionBrowserId/")
      end

      def option_max_crawl_depth : JSON::Any
        @client.request("/JSON/ajaxSpider/view/optionMaxCrawlDepth/")
      end

      def option_max_crawl_states : JSON::Any
        @client.request("/JSON/ajaxSpider/view/optionMaxCrawlStates/")
      end

      def option_max_duration : JSON::Any
        @client.request("/JSON/ajaxSpider/view/optionMaxDuration/")
      end

      def option_number_of_browsers : JSON::Any
        @client.request("/JSON/ajaxSpider/view/optionNumberOfBrowsers/")
      end

      def modify_excluded_element(context_name : String, description : String, element : String, description_new : String = "", xpath : String = "", text : String = "", attribute_name : String = "", attribute_value : String = "", enabled : String = "") : JSON::Any
        params = {} of String => String
        params["contextName"] = context_name
        params["description"] = description
        params["element"] = element
        params["descriptionNew"] = description_new unless description_new.empty?
        params["xpath"] = xpath unless xpath.empty?
        params["text"] = text unless text.empty?
        params["attributeName"] = attribute_name unless attribute_name.empty?
        params["attributeValue"] = attribute_value unless attribute_value.empty?
        params["enabled"] = enabled unless enabled.empty?
        @client.request("/JSON/ajaxSpider/action/modifyExcludedElement/", params)
      end

      def set_option_enable_extensions(enabled : Bool) : JSON::Any
        @client.request("/JSON/ajaxSpider/action/setOptionEnableExtensions/", {"Boolean" => enabled.to_s})
      end

      def set_option_logout_avoidance(enabled : Bool) : JSON::Any
        @client.request("/JSON/ajaxSpider/action/setOptionLogoutAvoidance/", {"Boolean" => enabled.to_s})
      end

      def set_option_scope_check(string : String) : JSON::Any
        params = {} of String => String
        params["String"] = string
        @client.request("/JSON/ajaxSpider/action/setOptionScopeCheck/", params)
      end

      def excluded_elements(context_name : String) : JSON::Any
        params = {} of String => String
        params["contextName"] = context_name
        @client.request("/JSON/ajaxSpider/view/excludedElements/", params)
      end

      def option_click_default_elems : JSON::Any
        @client.request("/JSON/ajaxSpider/view/optionClickDefaultElems/")
      end

      def option_click_elems_once : JSON::Any
        @client.request("/JSON/ajaxSpider/view/optionClickElemsOnce/")
      end

      def option_enable_extensions : JSON::Any
        @client.request("/JSON/ajaxSpider/view/optionEnableExtensions/")
      end

      def option_event_wait : JSON::Any
        @client.request("/JSON/ajaxSpider/view/optionEventWait/")
      end

      def option_logout_avoidance : JSON::Any
        @client.request("/JSON/ajaxSpider/view/optionLogoutAvoidance/")
      end

      def option_random_inputs : JSON::Any
        @client.request("/JSON/ajaxSpider/view/optionRandomInputs/")
      end

      def option_reload_wait : JSON::Any
        @client.request("/JSON/ajaxSpider/view/optionReloadWait/")
      end

      def option_scope_check : JSON::Any
        @client.request("/JSON/ajaxSpider/view/optionScopeCheck/")
      end
    end
  end
end
