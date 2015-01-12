module SnowAgent
  class Sender
    def initialize(queue, configuration)
      @report_uri = URI.join(configuration.server, "agent/metrics")
      @batch_size = configuration.batch_size
      @queue      = queue
      @metrics    = []
    end

    def run
      loop { process }
    end

    def process
      @metrics << @queue.pop

      if @metrics.any?
        payload = JSON.dump({ metrics: @metrics.map(&:to_h) })

        # TODO:
        # * requeue data on failure
        # * request timeout
        post_data(payload)

        @metrics.clear
      end
    end

    def post_data(payload)
      http = Net::HTTP.new(@report_uri.host, @report_uri.port)
      http.use_ssl = (@report_uri.scheme == "https")

      req = Net::HTTP::Post.new("#{@report_uri.path}?#{@report_uri.query}")
      req.body =  payload

      response = http.request(req)
      response
    end
  end
end
