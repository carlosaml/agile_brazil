#encoding: utf-8 
source 'http://rubygems.org'

gem 'rails', '3.2.17' # Issue #114 - 4.0.2 is target
gem 'jquery-rails', '3.1.0'
gem 'haml', '4.0.5'
gem 'will_paginate', '3.0.5'
gem 'formtastic', '2.2.1'
gem 'inherited_resources', '1.4.1'
gem 'has_scope', '0.6.0.rc'
gem 'devise', '3.2.4'
gem 'devise-encryptable', '0.1.2'
gem 'magic-localized_country_select', '0.2.0', require: 'localized_country_select'
gem 'brhelper', '3.3.0'
gem 'seed-fu', '2.3.0'
gem 'acts-as-taggable-on', '3.0.2'
gem 'cancan', '1.6.10'
gem 'acts_as_commentable', '3.0.1' # version 4.0.1 require rails 4
gem 'state_machine', '1.2.0'
gem 'validates_existence', '0.9.2'
gem 'goalie', '0.0.4'
gem 'airbrake', '3.1.16'
gem 'aws-ses', '0.5.0', require: 'aws/ses'
gem 'mysql2', '0.3.15'
gem 'doorkeeper', '1.0.0'

platforms :ruby do
  gem 'RedCloth', '4.2.9', require: 'redcloth'
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'therubyracer', '0.12.1'
  gem 'sass-rails', '3.2.6' # 4.0.1 for rails 4
  gem 'yui-compressor', '0.12.0'
  gem 'jquery-ui-rails', '4.1.1'
  gem 'coffee-rails', '3.2.2' # 4.0.1 for rails 4
  gem 'fancybox-rails', '0.2.1'
end

group :development do
  gem 'capistrano', '3.1.0', require: false
  gem 'capistrano-rails', '1.1.1', require: false
  gem 'capistrano-bundler', '1.1.2', require: false
  gem 'travis-lint', '1.8.0'
  gem 'foreman', '0.63.0'
  gem 'bullet', '4.8.0'
  gem 'lol_dba', '1.6.0'
end

group :test do
  gem 'mocha', '1.0.0'
  gem 'shoulda-matchers', '2.5.0'
  gem 'factory_girl_rails', '4.3.0'
  gem 'simplecov', '0.8.2'
  gem 'email_spec', '1.5.0'
end

group :development, :test do
  gem 'sqlite3', '1.3.9'
  gem 'rspec-rails', '2.14.2'
  gem 'spork-rails', '4.0.0'
  gem 'jasmine-jquery-rails', '1.5.6' # Requires jasmine 2 to upgrade but jasminerice doesnt support it
  gem 'guard-jasmine', '1.19.0'
  gem 'jasminerice', '0.0.10'
  gem 'coveralls', '0.7.0', require: false
end