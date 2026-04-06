require "spec"
require "http/server"
require "../src/zap"

# Mock ZAP server for testing API calls
class MockZapServer
  property last_path : String = ""
  property last_params : URI::Params = URI::Params.new
  property response_body : String = %({"Result": "OK"})
  property response_handler : Proc(String, URI::Params, String)?
  property server : HTTP::Server?

  def initialize(@port : Int32 = 0)
  end

  def start : Int32
    srv = HTTP::Server.new do |ctx|
      @last_path = ctx.request.path
      @last_params = ctx.request.query_params
      ctx.response.content_type = "application/json"
      if handler = @response_handler
        ctx.response.print handler.call(ctx.request.path, ctx.request.query_params)
      else
        ctx.response.print @response_body
      end
    end
    address = srv.bind_tcp("127.0.0.1", @port)
    @server = srv
    spawn { srv.listen }
    Fiber.yield
    address.port
  end

  def stop
    @server.try(&.close)
  end

  def client : Zap::Client
    port = start
    Zap::Client.new("http://127.0.0.1:#{port}", "test-api-key")
  end
end

def with_mock_zap(&)
  mock = MockZapServer.new
  client = mock.client
  begin
    yield mock, client
  ensure
    client.close
    mock.stop
  end
end
