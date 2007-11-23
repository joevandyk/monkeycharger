require File.dirname(__FILE__) + '/../../spec_helper'

describe "/people/list" do

  before(:each) do
    @smith = mock_model(Person)
    @jones = mock_model(Person)
    @smith.stub!(:name).and_return("Joe")
    @jones.stub!(:name).and_return("Joe")
    assigns[:people] = [@smith, @jones]
  end

  it "should display the list of people" do
    @smith.should_receive(:name).exactly(3).times.and_return("Smith")
    @jones.should_receive(:name).exactly(3).times.and_return("Jones")

    # Careful - this renders 'app/views/people/list.html.erb', not 'http://localhost/people/list'
    render "/people/list"

    response.should have_tag('ul') do
      with_tag('li', 'Name: Smith')
      with_tag('li', 'Name: Jones')
    end
  end

  it "should have a <div> tag with :id => 'a" do
    render "/people/list"
    response.should have_tag('div#a')
  end

  it "should have a <hr> tag with :id => 'spacer" do
    render "/people/list"
    response.should have_tag('hr#spacer')
  end
end
