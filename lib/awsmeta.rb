# frozen_string_literal: true

require 'net/http'
require 'json'
require 'uri'

require_relative 'awsmeta/check'
require_relative 'awsmeta/errors'
require_relative 'awsmeta/version'
require_relative 'awsmeta/helpers'

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

  def get(url)
    uri = URI.parse(url)
    req = Net::HTTP.new(uri.host, uri.port)
    req.read_timeout = read_timeout
    req.open_timeout = open_timeout
    req.start { |http| http.get(uri.to_s) }
  end

  def attempt_json_parse(string)
    JSON.parse(string)
  rescue JSON::ParserError
    string
  end

  def request(url)
    response = get(url)
    return { error: response.message, code: response.code } if
      response.code != '200'

    result = attempt_json_parse(response.body)
    { resource: result }
  end

  def query_meta_data(query)
    request(META_DATA_LATEST_URL % query)
  end

  def query_dynamic(query)
    request(META_DATA_LATEST_DYNAMIC_URL % query)
  end

  def fetch(query, method = 'query_meta_data')
    result = send(method, query)

    raise Awsmeta::Errors::ResourceNotFound, result[:message] unless
      result[:resource]

    result[:resource]
  end

  def credentials
    result = fetch("#{META_DATA_CREDENTIALS_PATH}/#{role}")
    Awsmeta::Helpers.symbolize_and_underscore_keys(result)
  end

  def document
    result = fetch(META_DATA_INSTANCE_IDENTITY_PATH, 'query_dynamic')
    Awsmeta::Helpers.symbolize_and_underscore_keys(result)
  end

  def instance_id
    fetch(META_DATA_INSTANCE_ID_PATH)
  end

  def role
    fetch(META_DATA_CREDENTIALS_PATH)
  end
end
