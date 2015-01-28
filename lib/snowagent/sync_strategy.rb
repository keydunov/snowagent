module SnowAgent
  class SyncStrategy
    def initialize(configuration)
      @service = Service.new(configuration)
    end

    def metric(metric)
      @service.post_data({ metrics: [metric.to_h]})
    end
  end
end
