require_relative "middlewares/request_header_middleware"
require_relative "models/user"
require_relative "../errors/external_service_exception"
require_relative "../errors/not_found_exception"
class MicroserviceClient
  def initialize(url)
    @user_microservice = Faraday.new(:url => url) do |faraday|
      faraday.use RequestHeaderMiddleware
      faraday.request :url_encoded # form-encode POST params
      faraday.response :logger # log requests to $stdout
      faraday.adapter Faraday.default_adapter # make requests with Net::HTTP
    end
  end

  def find(id)
    result = @user_microservice.get '/get_users_info', params = {:user_id => id}
    if result.status == 404
      puts "\n\n\nI am in if 404"
      raise NotFoundException.new("User was not found", result.body['message'], 404)
    end
    unless result.status == 200
      puts "\n\n\nI am in if 500"
      raise ExternalServiceException.new(result.body['message'])
    end
    User.new(JSON.parse(result.body))
  end

  def new_user(params)
    result = @user_microservice.post '/add_user', params
    if result.status != 200
      raise ExternalServiceException.new(result.body['message'])
    end
  end

  def edit_user(params)
    result = @user_microservice.post "/edit_user/#{params['user_id']}", params
    if result.status != 200
      raise ExternalServiceException.new(result.body['message'])
    end
  end
end