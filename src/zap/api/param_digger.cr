module Zap
  module Api
    class ParamDigger
      def initialize(@client : Zap::Client)
      end

      def hello_world : JSON::Any
        @client.request("/JSON/paramDigger/action/helloWorld/")
      end
    end
  end
end
