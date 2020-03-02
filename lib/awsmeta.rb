# frozen_string_literal: true

require 'net/http'
require 'json'
require 'uri'

# require gem ruby files
Dir[File.dirname(__FILE__) + '/**/*.rb'].sort.each { |file| require file }

# Awsmeta retrieves metadata from AWS EC2 instances
module Awsmeta
  module_function

  def credentials
    path = ResourcePaths::Metadata::CREDENTIALS_PATH
    result = Query.fetch("#{path}/#{role}")
    Helpers::Hash.symbolize_and_underscore_keys(result)
  end

  def document
    path = ResourcePaths::Dynamic::INSTANCE_IDENTITY_PATH
    result = Query.fetch(path, true)
    Helpers::Hash.symbolize_and_underscore_keys(result)
  end

  def instance_id
    Query.fetch(ResourcePaths::Metadata::INSTANCE_ID_PATH)
  end

  def role
    Query.fetch(ResourcePaths::Metadata::CREDENTIALS_PATH)
  end
end
