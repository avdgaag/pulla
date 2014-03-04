module Pulla
  class ApiClient
    attr_reader :base_uri, :authentication_query, :logger

    DEFAULT_HTTP_OPTIONS = {
      use_ssl: true,
      verify_mode: OpenSSL::SSL::VERIFY_NONE
    }.freeze

    def initialize(base_uri, id, token, logger)
      @base_uri = base_uri
      @logger = logger
      @authentication_query = URI.encode_www_form(
        client_id: id,
        client_secret: token
      )
      extend JsonApi, ApiCaching
    end

    def get(path, headers = {})
      r = Net::HTTP::Get.new(URI.join(base_uri, path)).tap do |req|
        headers.each do |key, value|
          req[key] = value
        end
      end
      request r
    end

    private

    def request(req)
      logger.info('ApiClient') { "#{req.class::METHOD} #{req.uri}" }
      logger.debug('ApiClient') { "Using headers: #{req.to_hash.inspect}" }
      req.uri.query = authentication_query
      Net::HTTP.start(req.uri.host, req.uri.port, DEFAULT_HTTP_OPTIONS) do |http|
        response = http.request(req)
        logger.info('ApiClient') { "#{response.code} #{response.message}" }
        case response
        when Net::HTTPNotModified, Net::HTTPSuccess
          response
        when Net::HTTPNotFound
          raise "Not found: #{req.uri}"
        else
          raise response.value
        end
      end
    end
  end
end
