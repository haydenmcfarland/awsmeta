# frozen_string_literal: true

module Awsmeta
  # contains methods used to request and parse metadata
  module Request
    module_function

    def get(url)
      uri = URI.parse(url)
      req = Net::HTTP.new(uri.host, uri.port)
      req.read_timeout = Awsmeta::Config.read_timeout
      req.open_timeout = Awsmeta::Config.open_timeout
      req.start { |http| http.get(uri.to_s) }
    end

    def safe_json_parse(string)
      JSON.parse(string)
    rescue JSON::ParserError
      string
    end

    def request(url)
      response = get(url)
      return { error: response.message, code: response.code } if
        response.code != '200'

      result = safe_json_parse(response.body)
      { resource: result }
    end
  end
end
