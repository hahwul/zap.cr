module Zap
  module Api
    class Automation
      def initialize(@client : Zap::Client)
      end

      def plan_progress(plan_id : Int32) : JSON::Any
        @client.request("/JSON/automation/view/planProgress/", {"planId" => plan_id.to_s})
      end

      def run_plan(file_path : String) : JSON::Any
        @client.request("/JSON/automation/action/runPlan/", {"filePath" => file_path})
      end

      def end_delay_job : JSON::Any
        @client.request("/JSON/automation/action/endDelayJob/")
      end
    end
  end
end
