module SnowAgent
  class Sender
    def initialize(queue, conf)
      @report_uri = URI.join(conf.server, "agent/metrics")
      @queue      = queue
      @conf       = conf
      @metrics    = []
    end

    def run
      loop { process }
    end

    def process
      @metrics << @queue.pop

      if @metrics.size >= @conf.batch_size
        payload = JSON.dump({ metrics: @metrics.map(&:to_h) })

        # TODO:
        # * requeue data on failure
        post_data(payload)

        @metrics.clear
      end
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
