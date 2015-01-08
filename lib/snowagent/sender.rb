module SnowAgent
  class Sender
    def initialize(queue)
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
      uri = SnowAgent.report_uri
      http = Net::HTTP.new(uri.host, uri.port)

      req = Net::HTTP::Post.new("#{uri.path}?#{uri.query}")
      req.body =  payload

      response = http.request(req)
      response
    end
  end
end
