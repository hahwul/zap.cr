module Zap
  module Api
    class Websocket
      def initialize(@client : Zap::Client)
      end

      def channels : JSON::Any
        @client.request("/JSON/websocket/view/channels/")
      end

      def message(channel_id : Int32, message_id : Int32) : JSON::Any
        @client.request("/JSON/websocket/view/message/", {"channelId" => channel_id.to_s, "messageId" => message_id.to_s})
      end

      def messages(channel_id : Int32 = -1, start : Int32 = -1, count : Int32 = -1, payload_preview_length : Int32 = -1) : JSON::Any
        params = {} of String => String
        params["channelId"] = channel_id.to_s if channel_id >= 0
        params["start"] = start.to_s if start >= 0
        params["count"] = count.to_s if count >= 0
        params["payloadPreviewLength"] = payload_preview_length.to_s if payload_preview_length >= 0
        @client.request("/JSON/websocket/view/messages/", params)
      end

      def send_text_message(channel_id : Int32, outgoing : Bool, message : String) : JSON::Any
        @client.request("/JSON/websocket/action/sendTextMessage/", {
          "channelId" => channel_id.to_s, "outgoing" => outgoing.to_s, "message" => message,
        })
      end

      def set_break_text_message(message : String, outgoing : String) : JSON::Any
        params = {} of String => String
        params["message"] = message
        params["outgoing"] = outgoing
        @client.request("/JSON/websocket/action/setBreakTextMessage/", params)
      end

      def break_text_message : JSON::Any
        @client.request("/JSON/websocket/view/breakTextMessage/")
      end
    end
  end
end
