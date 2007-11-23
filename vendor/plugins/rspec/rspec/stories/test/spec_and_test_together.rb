$:.push File.join(File.dirname(__FILE__), *%w[.. .. lib])
require 'spec'
require 'spec/extensions/test'

describe "spec" do
  it "should pass with assert" do
    assert true
  end

  it "should fail with assert" do
    assert false
  end

  it "should pass with should" do
    1.should == 1
  end

  it "should fail with should" do
    1.should == 2
  end
end

class NeighborlyTest < Test::Unit::TestCase
  def test_should_pass_with_assert
    assert true
  end
  
  def test_should_fail_with_assert
    assert false
  end

  def test_should_pass_with_should
    1.should == 1
  end
  
  def test_should_fail_with_should
    1.should == 2
  end
end