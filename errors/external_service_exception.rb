class ExternalServiceException < StandardError
    def initialize(message)
      @status = 500
      @message ="There is something wrong with the external service. Reason : #{message}. Status : 500"
      super(@message)
    end
end
