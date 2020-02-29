# frozen_string_literal: true

module Awsmeta
  # used to process metadata responses
  module Checker
    module_function

    # FIXME: this should be refined as this is not the best methodology
    def aws?
      return false if ENV['AWSMETA_DISABLE_AWS_CHECK'] == 'true'

      !Awsmeta.get(Awsmeta::META_DATA_BASE_URL).nil?
    rescue Net::OpenTimeout, Errno::EHOSTUNREACH
      false
    end
  end
end
