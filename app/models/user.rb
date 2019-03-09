require "faraday"
require "json"
require "rubygems"
require "active_record"
require_relative "../microservice_client"
class User
  attr_accessor :encrypted_password, :first_name, :last_name, :password, :email , :id

  def self.after_update(x, y)
    puts "zatichka"
  end

  def self.before_update(x, y)
    puts "zatichka"
  end

  def save
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
  def initialize(params = {})
    self.first_name = params['first_name']
    self.last_name = params['last_name']
    self.password = params['password']
    self.email = params['email']
    self.id = params['id']
    raise "YA tuta troshku pominyav"
    @@faraday = MicroserviceClient.new("http://microservice:3228")
  end

  def self.find(id)
    @@faraday.find(id)
  end

  def new_user(params)
    @@faraday.new_user(params)
  end

  def edit_user(params)
    @@faraday.edit_user(params)
  end
  def object_to_hash()
    hash = {}
    self.instance_variables.each {|var| hash[var.to_s.delete("@")] = self.instance_variable_get(var) }
    return hash
  end
end
