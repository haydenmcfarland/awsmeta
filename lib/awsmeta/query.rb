# frozen_string_literal: true

module Awsmeta
  # contains methods to query meta data
  module Query
    module_function

    def query_metadata(query)
      url = Awsmeta::Constants::METADATA_LATEST_URL
      Awsmeta::Request.request(url % query)
    end

    def query_dynamic(query)
      url = Awsmeta::Constants::METADATA_LATEST_DYNAMIC_URL
      Awsmeta::Request.request(url % query)
    end

    def fetch(query, dynamic = false)
      result = dynamic ? query_dynamic(query) : query_metadata(query)

      raise Awsmeta::Errors::ResourceNotFound, result[:error] unless
        result[:resource]

      result[:resource]
    end
  end
end
