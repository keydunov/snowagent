require 'json'
require 'uri'

require "snowagent/version"
require "snowagent/agent"
require "snowagent/sender"

module SnowAgent
  SNOWMAN_HOST = ENV["SNOWMAN_HOST"] || "http://localhost:4567"

  def self.metric(*args)
    Agent.instance.metric(*args)
  end

  def self.report_uri
    @report_uri ||= URI.join(SNOWMAN_HOST, "agent/metrics")
  end
end
