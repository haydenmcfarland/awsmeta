# frozen_string_literal: true

module Awsmeta
  # used to process metadata responses
  module Helpers
    # stripped from activesupport
    def underscore(camel_cased_word)
      return camel_cased_word unless /[A-Z-]|::/.match?(camel_cased_word)

      word = camel_cased_word.to_s.gsub('::', '/')
      word.gsub!(inflections.acronyms_underscore_regex) do
        "#{Regexp.last_match(1) && '_'}#{Regexp.last_match(2).downcase}"
      end

      word.gsub!(/([A-Z\d]+)([A-Z][a-z])/, '\1_\2')
      word.gsub!(/([a-z\d])([A-Z])/, '\1_\2')
      word.tr!('-', '_')
      word.downcase!
      word
    end

    def symbolize_keys(obj)
      obj.each_with_object({}) { |(k, v), h| h[underscore(k).to_sym] = v }
    end
  end
end
