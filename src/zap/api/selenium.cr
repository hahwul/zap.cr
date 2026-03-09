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
    end
  end
end
