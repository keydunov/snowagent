module SnowAgent
  class Configuration
    # Base URL of the SnowmanIO server
    attr_accessor :server

    # Secret access token for authentication with SnowmanIO
    attr_accessor :secret_token

    # Number of metrics sent per request
    attr_accessor :batch_size

    def initialize
      self.server       = ENV['SNOWMANIO_SERVER']
      self.secret_token = ENV['SNOWMANIO_SECRET_TOKEN']
      self.batch_size   = ENV['SNOWMANIO_BATCH_SIZE'] || 5
    end

    # Determines if the agent confiured to send metrics.
    def configured?
      !server.nil? && !batch_size.nil? # TODO: also check secret_token token
    end
  end
end
