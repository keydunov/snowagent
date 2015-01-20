module SnowAgent
  class AsyncStrategy
    def initialize(configuration)
      @queue = Queue.new
      run_sender(configuration)
    end

    def run_sender(conf)
      sender_thread = Thread.new { Sender.new(@queue, conf).run }
      sender_thread.abort_on_exception = true
    end

    def metric(metric)
      @queue.push(metric)
    end
  end
end
