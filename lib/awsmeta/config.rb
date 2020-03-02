# frozen_string_literal: true

module Awsmeta
  # contains configuration methods
  module Config
    module_function

    def read_timeout
      (ENV['AWSMETA_READ_TIMEOUT'] || 10).to_i
    end

    def open_timeout
      (ENV['AWSMETA_OPEN_TIMEOUT'] || 10).to_i
    end
  end
end
