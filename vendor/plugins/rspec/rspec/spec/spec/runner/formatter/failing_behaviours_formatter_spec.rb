require File.dirname(__FILE__) + '/../../../spec_helper'

module Spec
  module Runner
    module Formatter
      describe "FailingBehavioursFormatter" do
        before(:each) do
          @io = StringIO.new
          options = mock('options')
          @formatter = FailingBehavioursFormatter.new(options, @io)
        end
        
        def description(s)
          Spec::Example::ExampleGroupDescription.new(s)
        end

        it "should add example name for each failure" do
          @formatter.add_example_group(description("b 1"))
          @formatter.example_failed("e 1", nil, Reporter::Failure.new(nil, RuntimeError.new))
          @formatter.add_example_group(description("b 2"))
          @formatter.example_failed("e 2", nil, Reporter::Failure.new(nil, RuntimeError.new))
          @formatter.example_failed("e 3", nil, Reporter::Failure.new(nil, RuntimeError.new))
          @io.string.should eql(<<-EOF
b 1
b 2
EOF
)
        end

        it "should remove druby url, which is used by Spec::Distributed" do
          @formatter.add_example_group("something something (druby://99.99.99.99:99)")
          @formatter.example_failed("e 1", nil, Reporter::Failure.new(nil, RuntimeError.new))
          @io.string.should eql(<<-EOF
something something
EOF
)
        end
      end
    end
  end
end
