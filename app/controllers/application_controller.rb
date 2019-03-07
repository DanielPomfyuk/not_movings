require_relative "../../errors/external_service_exception"
require_relative "../../errors/not_found_exception"
class ApplicationController < ActionController::Base
  rescue_from ExternalServiceException do |exc|
    puts "#{exc.message}"
    render '../views/errors/error_500', status: 500
  end
  rescue_from NotFoundException do |exc|
    puts "\n\n\n\n i am in exception rescue"
    puts "#{exc.advanced_message}"
    render '../views/errors/error_404',locals: {reason: exc.user_message} , status: 404
  end
end
