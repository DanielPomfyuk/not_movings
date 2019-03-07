require "faraday_middleware"
class RequestHeaderMiddleware < Faraday::Middleware
  def initialize(app=nil)
    super(app)
  end
  def call(request_env)
    puts "\n\nBEFORE #{request_env[:request_headers]}"
    request_env[:request_headers].merge!("HTTP_ACCEPT" => "application/json")
    # request_env[:request_headers].merge!("content-type" => "application/json")
    puts "\n\nAFTER #{request_env[:request_headers]} "
    @app.call(request_env).on_complete do|a|
    end
  end
end