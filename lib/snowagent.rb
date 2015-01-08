require 'json'

require "snowagent/version"
require "snowagent/agent"
require "snowagent/sender"

module SnowAgent
  SNOWMAN_URI = "http://snowman-service-placehoder.herokuapp.com/"

  def self.metric(*args)
    Agent.instance.metric(*args)
  end
end
