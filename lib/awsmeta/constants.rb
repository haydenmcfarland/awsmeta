# frozen_string_literal: true

module Awsmeta
  module Constants
    # aws reserved host used to get instance meta-data
    METADATA_HOST = '169.254.169.254'
    METADATA_BASE_URL = "http://#{METADATA_HOST}"
    METADATA_LATEST_BASE_URL = "#{METADATA_BASE_URL}/latest/%s"
    METADATA_LATEST_URL = "#{METADATA_LATEST_BASE_URL % 'meta-data'}/%s"
    METADATA_LATEST_DYNAMIC_URL = "#{METADATA_LATEST_BASE_URL % 'dynamic'}/%s"
  end
end
