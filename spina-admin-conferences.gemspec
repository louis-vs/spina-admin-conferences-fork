# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)

# Maintain your gem's version:
require 'spina/admin/conferences/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name = 'spina-admin-conferences-fork'
  spec.version = Spina::Admin::Conferences::VERSION
  spec.authors = ['Louis Van Steene', 'Justin Malčić']
  spec.email = ['louis@lvs.me.uk', 'j.malcic@me.com']
  spec.homepage = 'https://jmalcic.github.io/projects/spina-admin-conferences'
  spec.summary = 'Conference management plugin for Spina.'
  spec.description = 'Keep track of conference attendees and presentations with this plugin.'
  spec.license = 'MIT'
  spec.required_ruby_version = '~> 2.7'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  raise 'RubyGems 2.0 or newer is required to protect against public gem pushes.' unless spec.respond_to?(:metadata)

  spec.metadata['rubygems_mfa_required'] = 'true'

  spec.files = Dir['{app,config,db,lib,vendor}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']

  spec.add_dependency 'icalendar', '~> 2.5'
  spec.add_dependency 'mobility-actiontext', '0.2.0'
  spec.add_dependency 'rails', '~> 6.0'
  spec.add_dependency 'rails-i18n', '~> 6.0'
  spec.add_dependency 'redis', '~> 4.2'
  spec.add_dependency 'spina', '~> 2.0.0'
  spec.add_dependency 'stimulus-rails', '>= 0.2.2', '< 1.1.0'
  spec.add_dependency 'turbo-rails', '~> 0.5.9'

  spec.add_development_dependency 'capybara', '~> 3.33'
  spec.add_development_dependency 'dotenv-rails', '~> 2.7'
  spec.add_development_dependency 'image_processing', '~> 1.12'
  spec.add_development_dependency 'minitest-rails', '~> 6.0'
  spec.add_development_dependency 'minitest-reporters', '~> 1.4'
  spec.add_development_dependency 'percy-capybara', '~> 4.3'
  spec.add_development_dependency 'puma', '~> 5.0'
  spec.add_development_dependency 'reek', '~> 6.0'
  spec.add_development_dependency 'rubocop', '~> 1.8'
  spec.add_development_dependency 'rubocop-performance', '~> 1.8'
  spec.add_development_dependency 'rubocop-rails', '~> 2.8'
  spec.add_development_dependency 'selenium-webdriver', '~> 3.142'
  spec.add_development_dependency 'sidekiq', '~> 6.1'
  spec.add_development_dependency 'simplecov', '~> 0.19'
  spec.add_development_dependency 'simplecov-lcov', '~> 0.8'
  spec.add_development_dependency 'web-console', '~> 4.0'
  spec.add_development_dependency 'webdrivers', '~> 4.4'
end
