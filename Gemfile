# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.2'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'hotwire-rails'
gem 'newrelic_rpm'
gem 'newrelic_rpm'
gem 'rails', '~> 6.1'
# Use postgresql as the database for Active Record
gem 'pg', '>= 0.18', '< 2.0'
# Use Puma as the app server
gem "puma", ">= 4.3.11"
# Use SCSS for stylesheets
gem 'sass-rails', '>= 6'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker', git: 'https://github.com/rails/webpacker.git'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.7'
# Use Redis adapter to run Action Cable in production
gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# https://github.com/paulelliott/fabrication
gem 'active_link_to'
gem 'activestorage-aliyun'
gem 'acts-as-taggable-on', '~> 9.0.0'
gem 'friendly_id', '~> 5.2.4'
gem 'nokogiri', '>= 1.11.0'
gem 'redcarpet', '>= 3.5.1'
gem 'simple_form'

gem 'inherited_resources'
gem 'responders'

# https://github.com/rubocop-hq/rubocop
gem 'rubocop', '~> 1.16', require: false

# Plus integrations with:
gem 'cancancan'
gem 'devise', '~> 4.7.2'
gem 'draper'
gem 'pundit'

gem "addressable", ">= 2.8.0"

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2', require: false

gem 'will_paginate', '~> 3.3.0'

# https://github.com/kjvarga/sitemap_generator
gem 'sitemap_generator', '~> 6.1.2'

# https://github.com/jumph4x/canonical-rails
gem 'canonical-rails', github: 'jumph4x/canonical-rails'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'pry'
  # https://github.com/deivid-rodriguez/pry-byebug
  gem 'factory_bot_rails'
  gem 'pry-byebug'
  gem 'rspec-html-matchers'
  gem 'rspec_junit_formatter'
  gem 'rspec-rails', '~> 4.0.0.beta'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'web-console', '>= 3.3.0'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'capistrano', '~> 3.10', require: false
  gem 'capistrano3-puma', '~> 4.0.0', require: false
  gem 'capistrano-bundler', '~> 1.5', require: false
  gem 'capistrano-db-tasks', github: 'lanzhiheng/capistrano-db-tasks', require: false
  gem 'capistrano-rails', '~> 1.4', require: false
  gem 'capistrano-rbenv', require: false
  gem 'rails_real_favicon'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  # Easy installation and use of web drivers to run system tests with browsers
  gem 'webdrivers'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
