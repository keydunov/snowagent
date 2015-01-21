module SnowAgent
  class Agent
    def initialize(configuration)
      strategy_class = configuration.async ? AsyncStrategy : SyncStrategy
      @strategy      = strategy_class.new(configuration)
    end

    Metric = Struct.new(:name, :value, :at)

    def metric(key, value, time = Time.now.to_i)
      @strategy.metric(Metric.new(key, value, time))
    end
  end
end
