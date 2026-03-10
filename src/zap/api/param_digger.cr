module Zap
  module Api
    class ParamDigger
      def initialize(@client : Zap::Client)
      end

      def hello_world : JSON::Any
        params = {} of String => String
        @client.request("/JSON/paramDigger/action/helloWorld/", params)
      end
    end
  end
end
