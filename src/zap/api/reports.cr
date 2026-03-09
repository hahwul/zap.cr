module Zap
  module Api
    class Reports
      def initialize(@client : Zap::Client)
      end

      # Views
      def templates : JSON::Any
        @client.request("/JSON/reports/view/templates/")
      end

      def template_details(template : String) : JSON::Any
        @client.request("/JSON/reports/view/templateDetails/", {"template" => template})
      end

      # Actions
      def generate(title : String, template : String, theme : String = "", description : String = "",
                   contexts : String = "", sites : String = "", sections : String = "",
                   included_confidences : String = "", included_risks : String = "",
                   report_file_name : String = "", report_file_name_pattern : String = "",
                   report_dir : String = "", display : Bool = false) : JSON::Any
        params = {"title" => title, "template" => template}
        params["theme"] = theme unless theme.empty?
        params["description"] = description unless description.empty?
        params["contexts"] = contexts unless contexts.empty?
        params["sites"] = sites unless sites.empty?
        params["sections"] = sections unless sections.empty?
        params["includedConfidences"] = included_confidences unless included_confidences.empty?
        params["includedRisks"] = included_risks unless included_risks.empty?
        params["reportFileName"] = report_file_name unless report_file_name.empty?
        params["reportFileNamePattern"] = report_file_name_pattern unless report_file_name_pattern.empty?
        params["reportDir"] = report_dir unless report_dir.empty?
        params["display"] = display.to_s
        @client.request("/JSON/reports/action/generate/", params)
      end
    end
  end
end
