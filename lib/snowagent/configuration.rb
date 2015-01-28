module SnowAgent
  class Configuration
    # Base URL of the SnowmanIO server
    attr_accessor :server

    # Secret access token for authentication with SnowmanIO
    attr_accessor :secret_token

    # Interval for reporting data to the server
    attr_accessor :send_interval

    # Timeout when waiting for the server to return data in seconds
    attr_accessor :read_timeout

    # Timout when opening connection to the server
    attr_accessor :open_timeout

    # Whether send metrics asynchronously or not
    attr_accessor :async

    def initialize
      self.server        = ENV['SNOWMANIO_SERVER']
      self.secret_token  = ENV['SNOWMANIO_SECRET_TOKEN']
      self.send_interval = 15

      self.read_timeout = 1
      self.open_timeout = 1

      self.async        = true
    end

    # Determines if the agent confiured to send metrics.
    def configured?
      !server.nil? # TODO: also check secret_token token
    end
  end
end
