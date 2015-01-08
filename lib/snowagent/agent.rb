module SnowAgent
  class Agent
    def self.instance
      @instance ||= new
    end

    def initialize
      @queue = Queue.new

      Thread.new do
        Sender.new(@queue).run
      end
    end

    Metric = Struct.new(:name, :value, :at)

    def metric(key, value, time = Time.now.to_i)
      @queue.push(Metric.new(key, value, time))
    end
  end
end
