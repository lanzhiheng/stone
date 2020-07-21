# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.5'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.0.3', '>= 6.0.3.2'

# Use postgresql as the database for Active Record
gem 'pg', '>= 0.18', '< 2.0'
# Use Puma as the app server
gem 'puma', '~> 4.3'
# Use SCSS for stylesheets
gem 'sass-rails', '>= 6'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker', '~> 4.0'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.7'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

gem 'activeadmin'
gem 'acts-as-taggable-on', '~> 6.0'
gem 'arctic_admin'
gem 'aws-sdk-s3', '~> 1'
gem 'friendly_id', '~> 5.2.4'
gem 'redcarpet', '~> 2.3.0'

# https://github.com/rubocop-hq/rubocop
gem 'rubocop', '~> 0.88.0', require: false

# Plus integrations with:
gem 'cancancan'
gem 'devise'
gem 'draper'
gem 'pundit'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2', require: false

gem 'will_paginate', '~> 3.2.1'

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
  gem 'capistrano3-puma', require: false
  gem 'capistrano-bundler', '~> 1.5', require: false
  gem 'capistrano-db-tasks', require: false
  gem 'capistrano-rails', '~> 1.4', require: false
  gem 'capistrano-rbenv', require: false
  gem 'rails_real_favicon'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
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
