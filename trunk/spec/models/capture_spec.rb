require File.dirname(__FILE__) + '/../spec_helper'

describe Capture do
  before(:each) do
    @capture = Capture.new
  end

  it "should respond_to :capture!" do
     @capture.should respond_to(:capture!)
  end
end
