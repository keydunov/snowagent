module SnowAgent
  class Sender
    def initialize(queue, conf)
      @queue      = queue
      @service    = Service.new(conf)
      @conf       = conf
      @metrics    = []
      @send_at    = Time.now.to_i + @conf.send_interval
    end

    def run
      loop { process }
    end

    def process
      # Pop metrics from the queue
      while !@queue.empty?
        @metrics << @queue.pop
      end

      if @send_at <= Time.now.to_i
        @send_at = Time.now.to_i + @conf.send_interval
        send_data if @metrics.any?
      end

      sleep 1
    end

    def send_data
      # TODO:
      # * requeue data on failure
      @service.post_data({ metrics: @metrics.map(&:to_h) })

      @metrics.clear
    end
  end
end
