# frozen_string_literal: true

require File.expand_path('lib/omniauth/version', __dir__)

Gem::Specification.new do |gem|
  gem.authors = ['Regalijan']
  gem.files = `git ls-files`.split("\n")
  gem.homepage = 'https://github.com/Regalijan/omniauth-roblox'
  gem.license = 'MIT'
  gem.name = 'omniauth-roblox'
  gem.required_ruby_version = '>= 2.7.2'
  gem.summary = 'OmniAuth strategy for Roblox'
  gem.version = OmniAuth::Roblox::VERSION

  gem.add_dependency 'omniauth', '~> 2.1'
  gem.add_dependency 'omniauth-oauth2', '~> 1.8'
end
