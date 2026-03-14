module Zap
  module Api
    class Selenium
      def initialize(@client : Zap::Client)
      end

      def option_browser_arguments : JSON::Any
        @client.request("/JSON/selenium/view/optionBrowserArguments/")
      end

      def option_chrome_binary_path : JSON::Any
        @client.request("/JSON/selenium/view/optionChromeBinaryPath/")
      end

      def option_chrome_driver_path : JSON::Any
        @client.request("/JSON/selenium/view/optionChromeDriverPath/")
      end

      def option_firefox_binary_path : JSON::Any
        @client.request("/JSON/selenium/view/optionFirefoxBinaryPath/")
      end

      def option_firefox_driver_path : JSON::Any
        @client.request("/JSON/selenium/view/optionFirefoxDriverPath/")
      end

      def set_option_chrome_binary_path(path : String) : JSON::Any
        @client.request("/JSON/selenium/action/setOptionChromeBinaryPath/", {"String" => path})
      end

      def set_option_chrome_driver_path(path : String) : JSON::Any
        @client.request("/JSON/selenium/action/setOptionChromeDriverPath/", {"String" => path})
      end

      def set_option_firefox_binary_path(path : String) : JSON::Any
        @client.request("/JSON/selenium/action/setOptionFirefoxBinaryPath/", {"String" => path})
      end

      def set_option_firefox_driver_path(path : String) : JSON::Any
        @client.request("/JSON/selenium/action/setOptionFirefoxDriverPath/", {"String" => path})
      end

      def add_browser_argument(browser : String, argument : String, enabled : String = "") : JSON::Any
        params = {} of String => String
        params["browser"] = browser
        params["argument"] = argument
        params["enabled"] = enabled unless enabled.empty?
        @client.request("/JSON/selenium/action/addBrowserArgument/", params)
      end

      def launch_browser(browser : String) : JSON::Any
        params = {} of String => String
        params["browser"] = browser
        @client.request("/JSON/selenium/action/launchBrowser/", params)
      end

      def remove_browser_argument(browser : String, argument : String) : JSON::Any
        params = {} of String => String
        params["browser"] = browser
        params["argument"] = argument
        @client.request("/JSON/selenium/action/removeBrowserArgument/", params)
      end

      def set_browser_argument_enabled(browser : String, argument : String, enabled : String) : JSON::Any
        params = {} of String => String
        params["browser"] = browser
        params["argument"] = argument
        params["enabled"] = enabled
        @client.request("/JSON/selenium/action/setBrowserArgumentEnabled/", params)
      end

      def set_option_firefox_default_profile(string : String) : JSON::Any
        params = {} of String => String
        params["String"] = string
        @client.request("/JSON/selenium/action/setOptionFirefoxDefaultProfile/", params)
      end

      def set_option_ie_driver_path(string : String) : JSON::Any
        params = {} of String => String
        params["String"] = string
        @client.request("/JSON/selenium/action/setOptionIeDriverPath/", params)
      end

      def set_option_last_directory(string : String) : JSON::Any
        params = {} of String => String
        params["String"] = string
        @client.request("/JSON/selenium/action/setOptionLastDirectory/", params)
      end

      def set_option_phantom_js_binary_path(string : String) : JSON::Any
        params = {} of String => String
        params["String"] = string
        @client.request("/JSON/selenium/action/setOptionPhantomJsBinaryPath/", params)
      end

      def get_browser_arguments(browser : String) : JSON::Any
        params = {} of String => String
        params["browser"] = browser
        @client.request("/JSON/selenium/view/getBrowserArguments/", params)
      end

      def option_browser_extensions : JSON::Any
        @client.request("/JSON/selenium/view/optionBrowserExtensions/")
      end

      def option_firefox_default_profile : JSON::Any
        @client.request("/JSON/selenium/view/optionFirefoxDefaultProfile/")
      end

      def option_ie_driver_path : JSON::Any
        @client.request("/JSON/selenium/view/optionIeDriverPath/")
      end

      def option_last_directory : JSON::Any
        @client.request("/JSON/selenium/view/optionLastDirectory/")
      end

      def option_phantom_js_binary_path : JSON::Any
        @client.request("/JSON/selenium/view/optionPhantomJsBinaryPath/")
      end
    end
  end
end
