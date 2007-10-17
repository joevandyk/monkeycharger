require File.dirname(__FILE__) + '/../spec_helper'

# This is very important!
describe BigDecimal do
  it "should do to_cents correctly" do
    b = BigDecimal.new('5.99')
    b.to_cents.should == 599
  end
end
