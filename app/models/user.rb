require "faraday"
require "json"
require "rubygems"
require "active_record"
require_relative "../middlewares/request_header_middleware"
require_relative "../../errors/external_service_exception"
require_relative "../../errors/not_found_exception"
class User
  attr_accessor :encrypted_password, :first_name, :last_name, :password, :email , :id

  def self.after_update(x, y)
    puts "zatichka"
  end

  def self.before_update(x, y)
    puts "zatichka"
  end

  def save
    puts "YA ZDES"
    if self.id == nil
      new_user(self.object_to_hash)
    else
      edit_user(self.object_to_hash)
    end
  end

  def persisted?
    puts "\n\n\n\n\nTHIS IS PERSISTED"
    return true
  end

  def to_key
    return ["User_id"]
  end

  class OOO
    def self.get(key)
      User.new
    end
  end

  def self.to_adapter
    OOO
  end

  include ActiveModel::Validations #required because some before_validations are defined in devise
  extend ActiveRecord::Validations::ClassMethods #required because some before_validations are defined in devise
  extend ActiveModel::Callbacks #required to define callbacks
  extend Devise::Models
  define_model_callbacks :validation #required by Devise
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  @@user_microservice = Faraday.new(:url => 'http://localhost:3228') do |faraday|
    faraday.use RequestHeaderMiddleware
    faraday.request :url_encoded # form-encode POST params
    faraday.response :logger # log requests to $stdout
    faraday.adapter Faraday.default_adapter # make requests with Net::HTTP
  end
  @@ad_microservice = Faraday.new(:url => 'http://localhost:7777') do |faraday|
    faraday.use RequestHeaderMiddleware
    faraday.request :url_encoded # form-encode POST params
    faraday.response :logger # log requests to $stdout
    faraday.adapter Faraday.default_adapter # make requests with Net::HTTP
  end

  def initialize(params = {})
    self.first_name = params['first_name']
    self.last_name = params['last_name']
    self.password = params['password']
    self.email = params['email']
    self.id = params['id']
  end

  def self.find(id)
    result = @@user_microservice.get '/get_users_info', params = {:user_id => id}
    if result.status == 404
      puts "\n\n\nI am in if 404"
      raise NotFoundException.new("User was not found",result.body['message'],404)
    end
    unless result.status == 200
      puts "\n\n\nI am in if 500"
      raise ExternalServiceException.new(result.body['message'])
    end
    User.new(JSON.parse(result.body))
  end

  def new_user(params)
    puts "\n\n\n i am in new user"
    result = @@user_microservice.post '/add_user', params
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
  def object_to_hash()
    hash = {}
    self.instance_variables.each {|var| hash[var.to_s.delete("@")] = self.instance_variable_get(var) }
    return hash
  end
end
