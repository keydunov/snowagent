module SnowAgent
  # Encapsulates HTTP related logic for sending data
  # to SnowmanIO instance
  # TODO: use faraday instead of raw net/http?
  class Service
    def initialize(conf)
      @uri        =  URI.join(conf.server, "agent/metrics")
      @connection = build_connection(conf)
    end

    def post_data(payload)
      req = Net::HTTP::Post.new("#{@uri.path}?#{@uri.query}")
      req.body =  JSON.dump(payload)

      response = @connection.request(req)

      response
    end

    def build_connection(conf)
      http = Net::HTTP.new(@uri.host, @uri.port)

      http.use_ssl      = (@uri.scheme == "https")
      http.read_timeout = conf.read_timeout if conf.read_timeout
      http.open_timeout = conf.open_timeout if conf.open_timeout

      http
    end
  end
end
