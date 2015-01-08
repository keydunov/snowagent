module SnowAgent
  class Agent
    def self.instance
      @instance ||= new
    end

    def initialize
      @queue = Queue.new
      run_sender
    end

    def run_sender
      sender_thread = Thread.new { Sender.new(@queue).run }
      sender_thread.abort_on_exception = true
    end

    Metric = Struct.new(:name, :value, :at)

    def metric(key, value, time = Time.now.to_i)
      @queue.push(Metric.new(key, value, time))
    end
  end
end
