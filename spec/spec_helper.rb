# encoding: UTF-8
# This file is copied to spec/ when you run 'rails generate rspec:install'

require 'spork'
# uncomment the following line to use spork with the debugger
# require 'spork/ext/ruby-debug'
#
Spork.prefork do
  ENV["RAILS_ENV"] ||= 'test'
  require File.expand_path("../../config/environment", __FILE__)
  require 'rspec/rails'
  require 'rspec/autorun'
  require 'cancan/matchers'
  require 'coveralls'
  Coveralls.wear!('rails')

  # Requires supporting ruby files with custom matchers and macros, etc,
  # in spec/support/ and its subdirectories.
  Dir[::Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

  ::Rails.logger.level = 4

  module Airbrake
    def self.notify(thing)
      # do nothing.
    end
  end

  RSpec.configure do |config|
    config.include(ControllerMacros, :type => :controller)
    config.include(DisableAuthorization, :type => :controller)
    config.include(Devise::TestHelpers, :type => :controller)
    config.include(EmailSpec::Helpers, :type => :mailer)
    config.include(EmailSpec::Matchers, :type => :mailer)
    config.include(TrimmerMacros)
    config.include(ValidatesExistenceMacros)

    # == Mock Framework
    #
    # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
    #
    config.mock_with :mocha
    # config.mock_with :flexmock
    # config.mock_with :rr
    # config.mock_with :rspec

    # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
    config.fixture_path = "#{::Rails.root}/spec/fixtures"

    # If you're not using ActiveRecord, or you'd prefer not to run each of your
    # examples within a transaction, remove the following line or assign false
    # instead of true.
    config.use_transactional_examples = true
    config.use_instantiated_fixtures = false

    # If true, the base class of anonymous controllers will be inferred
    # automatically. This will be the default behavior in future versions of
    # rspec-rails.
    config.infer_base_class_for_anonymous_controllers = false

    # Run specs in random order to surface order dependencies. If you find an
    # order dependency and want to debug it, you can fix the order by providing
    # the seed, which is printed after each run.
    #     --seed 1234
    config.order = "random"
  end
end

Spork.each_run do
  AgileBrazil::Application.reload_routes!
end
