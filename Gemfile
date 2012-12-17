source 'http://rubygems.org'

gem 'rails', '=3.1.3'
gem 'jquery-rails', '=1.0.19'
gem 'haml', '=3.1.4'
gem 'will_paginate', '=3.0.3'
gem 'formtastic', '=2.0.2'
gem 'inherited_resources', '=1.3.0'
gem 'has_scope', '=0.5.1'
gem 'devise', '=2.0.4'
gem 'brhelper', '=3.0.8'
gem 'brcpfcnpj', '=3.0.8'
gem 'seed-fu', '=2.2.0'
gem 'acts-as-taggable-on', '=2.2.2'
gem 'cancan', '=1.6.7'
gem 'acts_as_commentable', '=3.0.1'
gem 'state_machine', '=1.1.2'
gem 'validates_existence', '=0.7.1'
gem 'goalie', '=0.0.4'
gem 'airbrake', '=3.0.9'
gem 'aws-ses', '=0.4.4', :require => 'aws/ses'

platforms :mswin, :mingw do
  gem 'RedCloth', '=4.2.9', :require => 'redcloth', :platforms => :mswin
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails', '=3.1.5'
  gem 'yui-compressor', '=0.9.6'
  gem 'johnson', '=1.2.0'
end

platforms :ruby do
  gem 'RedCloth', '=4.2.9', :require => 'redcloth'
end

group :production do
  gem 'mysql2', '=0.3.11'
end

group :development do
  gem 'mysql2', '=0.3.11'
  gem 'sqlite3', '=1.3.5'
  gem 'capistrano-ext', '=1.2.1'
end

group :development, :test do
  gem 'mocha', '=0.10.4'
  gem 'rspec-rails', '=2.8.1'
  gem 'shoulda-matchers', '=1.0.0'
  gem 'factory_girl_rails', '=1.6.0'
end