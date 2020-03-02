# frozen_string_literal: true

module Awsmeta
  # used to process metadata responses
  module Helpers
    # a set of hash processors
    module Hash
      module_function

      def underscore(camel_cased_word)
        return camel_cased_word unless /[A-Z-]|::/.match?(camel_cased_word)

        word = camel_cased_word.to_s.gsub('::', '/')
        word.gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
            .gsub(/([a-z\d])([A-Z])/, '\1_\2')
            .tr('-', '_')
            .downcase
      end

      def symbolize_and_underscore_keys(obj)
        obj.each_with_object({}) { |(k, v), h| h[underscore(k).to_sym] = v }
      end
    end
  end
end
