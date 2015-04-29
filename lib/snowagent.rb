require 'json'
require 'uri'
require 'logger'

require "snowagent/version"
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

    def time(key)
      start = Time.now
      result = yield
      metric(key, ((Time.now - start) * 1000).round, "time")
      result
    end

    def configure
      yield(configuration)
      # do not trigger initialization if not configured
      self.agent if configuration.configured?
    end
  end
end
