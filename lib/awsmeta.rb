# frozen_string_literal: true

require 'uri'
require 'net/http'
require_relative 'awsmeta/version'

# Awsmeta retrieves metadata from AWS EC2 instances
module Awsmeta
  # aws reserved host used to get instance meta-data
  META_DATA_HOST = '169.254.169.254'
  META_DATA_BASE_URL = "http://#{META_DATA_HOST}"
  META_DATA_LATEST_BASE_URL = "#{META_DATA_BASE_URL}/latest/%s"
  META_DATA_LATEST_URL = "#{META_DATA_LATEST_BASE_URL % 'meta-data'}/%s"
  META_DATA_LATEST_DYNAMIC_URL = "#{META_DATA_LATEST_BASE_URL % 'dynamic'}/%s"
  META_DATA_CREDENTIALS_PATH = 'iam/security-credentials'
  META_DATA_INSTANCE_ID_PATH = 'instance-id'
  META_DATA_INSTANCE_IDENTITY_PATH = 'instance-identity/document'

  class << self
    def aws?
      return false if ENV['AWSMETA_DISABLE_AWS_CHECK'] == 'true'

      begin
        get(META_DATA_BASE_URL).present?
      rescue StandardError
        nil
      end
    end

    def self.request_timeout
      ENV['AWSMETA_REQUEST_TIMEOUT'] || 1
    end

    def self.get(url)
      uri = URI.parse(url)
      req = Net::HTTP.new(uri.host, uri.port)
      req.read_timeout = req.open_timeout = request_timeout
      req.start { |http| http.get(uri.to_s) }.body
    end

    def query_meta_data(query)
      get(META_DATA_LATEST_URL % query)
    end

    def query_dynamic(query)
      get(META_DATA_LATEST_DYNAMIC_URL % query)
    end

    def sym(obj)
      obj.each_with_object({}) { |(k, v), h| h[k.underscore.to_sym] = v }
    end

    def credentials
      sym(JSON.parse(query_meta_data("#{META_DATA_CREDENTIALS_PATH}/#{role}")))
    end

    def document
      sym(JSON.parse(query_dynamic(META_DATA_INSTANCE_IDENTITY_PATH)))
    end

    def instance_id
      query_meta_data(META_DATA_INSTANCE_ID_PATH)
    end

    def role
      query_meta_data(META_DATA_CREDENTIALS_PATH)
    end
  end
end
