require 'spec/version'
require 'spec/matchers'
require 'spec/expectations'
require 'spec/translator'
require 'spec/example'
require 'spec/extensions'
require 'spec/runner'
require 'spec/story'

if Object.const_defined?(:Test); \
  require 'spec/extensions/test'; \
end
module Spec
  class << self
    def run?
      @run || rspec_options.examples_run?
    end

    def run; \
      return true if run?; \
      result = rspec_options.run_examples; \
      @run = true; \
      result; \
    end
    attr_writer :run

    def exit?; \
      !Object.const_defined?(:Test) || Test::Unit.run?; \
    end
  end
end

at_exit do \
  unless $! || Spec.run?; \
    success = Spec.run; \
    exit success if Spec.exit?; \
  end \
end