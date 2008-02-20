RAILS_GEM_VERSION = '1.2.3' unless defined? RAILS_GEM_VERSION

require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  config.action_controller.session = { :disabled => true }
end

require 'lib/big_decimal'
raise "\n\n!!! Make sure to create and modify config/initializers/monkeycharger.rb!  (sample in config/initializers/monkeycharger.rb.example) !!!\n\n" unless File.exist?("config/initializers/monkeycharger.rb")
