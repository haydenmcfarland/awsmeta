# frozen_string_literal: true

require 'uri'
require 'net/http'
require 'json'
require_relative 'awsmeta/version'
require_relative 'awsmeta/helpers'
require_relative 'awsmeta/checker'

# Awsmeta retrieves metadata from AWS EC2 instances
module Awsmeta
  module_function

  # aws reserved host used to get instance meta-data
  META_DATA_HOST = '169.254.169.254'
  META_DATA_BASE_URL = "http://#{META_DATA_HOST}"
  META_DATA_LATEST_BASE_URL = "#{META_DATA_BASE_URL}/latest/%s"
  META_DATA_LATEST_URL = "#{META_DATA_LATEST_BASE_URL % 'meta-data'}/%s"
  META_DATA_LATEST_DYNAMIC_URL = "#{META_DATA_LATEST_BASE_URL % 'dynamic'}/%s"
  META_DATA_CREDENTIALS_PATH = 'iam/security-credentials'
  META_DATA_INSTANCE_ID_PATH = 'instance-id'
  META_DATA_INSTANCE_IDENTITY_PATH = 'instance-identity/document'

  def read_timeout
    (ENV['AWSMETA_READ_TIMEOUT'] || 10).to_i
  end

  def open_timeout
    (ENV['AWSMETA_OPEN_TIMEOUT'] || 10).to_i
  end

  def request(url)
    uri = URI.parse(url)
    request = Net::HTTP.new(uri.host, uri.port)
    request.read_timeout = read_timeout
    request.open_timeout = open_timeout
    request.start { |http| http.get(uri.to_s) }
  end

  def attempt_json_parse(string)
    JSON.parse(string)
  rescue JSON::ParserError
    string
  end

  def get(url)
    response = request(url)
    return { error: response.message, code: response.code } if
      response.code != '200'

    result = attempt_json_parse(response.body)
    result.is_a?(String) ? { resource: result } : result
  end

  def query_meta_data(query)
    get(META_DATA_LATEST_URL % query)
  end

  def query_dynamic(query)
    get(META_DATA_LATEST_DYNAMIC_URL % query)
  end

  def credentials
    result = role
    return result unless result[:resource]

    Awsmeta::Helpers.symbolize_and_underscore_keys(
      query_meta_data("#{META_DATA_CREDENTIALS_PATH}/#{result[:resource]}")
    )
  end

  def document
    Awsmeta::Helpers.symbolize_and_underscore_keys(
      query_dynamic(META_DATA_INSTANCE_IDENTITY_PATH)
    )
  end

  def instance_id
    result = query_meta_data(META_DATA_INSTANCE_ID_PATH)
    return result unless result[:resource]

    { instance_id: result[:resource] }
  end

  def role
    query_meta_data(META_DATA_CREDENTIALS_PATH)
  end
end
