# frozen_string_literal: true

module Awsmeta
  # used to process metadata responses
  module Extras
    # useful extras that help with integration
    module Discovery
      module_function

      # check for if code is executing on an ec2 instance
      def ec2?
        return false if ENV['AWSMETA_DISABLE_AWS_CHECK'] == 'true'

        !Awsmeta.instance_id.nil?
      rescue Net::OpenTimeout, Errno::EHOSTUNREACH
        false
      end
    end
  end
end
