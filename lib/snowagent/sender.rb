module SnowAgent
  class Sender
    def initialize(queue, conf)
      @report_uri = URI.join(conf.server, "agent/metrics")
      @queue      = queue
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
      payload = JSON.dump({ metrics: @metrics.map(&:to_h) })

      # TODO:
      # * requeue data on failure
      post_data(payload)

      @metrics.clear
    end

    # TODO: use faraday instead of raw net/http?
    def post_data(payload)
      http = Net::HTTP.new(@report_uri.host, @report_uri.port)

      http.use_ssl      = (@report_uri.scheme == "https")
      http.read_timeout = @conf.read_timeout if @conf.read_timeout
      http.open_timeout = @conf.open_timeout if @conf.open_timeout

      req = Net::HTTP::Post.new("#{@report_uri.path}?#{@report_uri.query}")
      req.body =  payload

      response = http.request(req)
      response
    end
  end
end
