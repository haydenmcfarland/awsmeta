# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require_relative 'lib/awsmeta/version'

Gem::Specification.new do |s|
  s.name = 'awsmeta'
  s.version = Awsmeta::VERSION
  s.authors = ['haydenmcfarland']
  s.email = ['mcfarlandsms@gmail.com']
  s.date = '2020-02-28'
  s.summary = 'AWS metadata loader'
  s.description = 'AWS metadata loader'
  s.homepage = 'https://github.com/haydenmcfarland/awsmeta'
  s.license = 'MIT'
  s.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end

  s.require_paths = ['lib']
end
