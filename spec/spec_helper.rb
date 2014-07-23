require_relative './../app'
require 'database_cleaner'
require 'capybara/rspec'

Capybara.app = App
App.set :database => :test

DatabaseCleaner.strategy = :transaction

RSpec.configure do |config|
  config.before(:suite) do
    DatabaseCleaner.start
  end

  config.after(:suite) do
    DatabaseCleaner.clean
  end
end