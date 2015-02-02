require 'json'
require 'uri'
require 'logger'

require "snowagent/version"
require "snowagent/railtie"
require "snowagent/agent"
require "snowagent/async_strategy"
require "snowagent/sync_strategy"
require "snowagent/sender"
require "snowagent/service"
require "snowagent/configuration"

module SnowAgent
  class << self
    attr_writer :configuration

    def logger
      @logger ||= Logger.new(STDOUT)
    end

    def configuration
      @configuration ||= Configuration.new
    end

    def agent
      @agent ||= Agent.new(configuration)
    end

    def metric(*args)
      if configuration.configured?
        agent.metric(*args)
      else
        # logger.debug "Metric was not send due to configuration."
      end

      nil
    end

    def configure
      yield(configuration)
      self.agent
    end
  end
end
