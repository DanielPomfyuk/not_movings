class NotFoundException < StandardError
  attr_accessor :status, :advanced_message, :user_message
  def initialize(user_message,advanced_message,status)
    self.advanced_message = advanced_message
    self.user_message = user_message
    self.status = status
    super(self.advanced_message)
  end
end