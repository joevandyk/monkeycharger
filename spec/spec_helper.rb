# This file is copied to ~/spec when you run 'ruby script/generate rspec'
# from the project root directory.
ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'spec'
require 'spec/rails'

Spec::Runner.configure do |config|
  config.use_transactional_fixtures = true
  config.use_instantiated_fixtures  = false
  config.fixture_path = RAILS_ROOT + '/spec/fixtures/'

  # You can declare fixtures for each behaviour like this:
  #   describe "...." do
  #     fixtures :table_a, :table_b
  #
  # Alternatively, if you prefer to declare them only once, you can
  # do so here, like so ...
  #
  #   config.global_fixtures = :table_a, :table_b
  #
  # If you declare global fixtures, be aware that they will be declared
  # for all of your examples, even those that don't use them.
end

DEFAULT_TEST_PASS = '12345'
def generate_credit_card options={}
   c = CreditCard.new({:passphrase => DEFAULT_TEST_PASS, :number => "4111111111111111", :month => Time.now.month, :year => Time.now.year, :name => "Joe Van Dyk", :street_address => '123 Main', :city => 'Albany', :state => 'OR', :zip => 12345, :country => 'U.S'}.merge(options))
   c.card_type = CreditCard::type?(c.number)
   c.save
   c
end
