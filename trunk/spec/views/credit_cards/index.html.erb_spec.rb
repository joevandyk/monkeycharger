require File.dirname(__FILE__) + '/../../spec_helper'

describe "/credit_cards/index.html.erb" do
  include CreditCardsHelper
  
  before do
    credit_card_98 = mock_model(CreditCard)
    credit_card_98.should_receive(:name).and_return("MyString")
    credit_card_98.should_receive(:number).and_return("MyString")
    credit_card_98.should_receive(:card_type).and_return("MyString")
    credit_card_98.should_receive(:month).and_return("MyString")
    credit_card_98.should_receive(:year).and_return("MyString")
    credit_card_98.should_receive(:cvv).and_return("MyString")
    credit_card_98.should_receive(:street_address).and_return("MyString")
    credit_card_98.should_receive(:city).and_return("MyString")
    credit_card_98.should_receive(:state).and_return("MyString")
    credit_card_98.should_receive(:country).and_return("MyString")
    credit_card_98.should_receive(:zip).and_return("MyString")
    credit_card_99 = mock_model(CreditCard)
    credit_card_99.should_receive(:name).and_return("MyString")
    credit_card_99.should_receive(:number).and_return("MyString")
    credit_card_99.should_receive(:card_type).and_return("MyString")
    credit_card_99.should_receive(:month).and_return("MyString")
    credit_card_99.should_receive(:year).and_return("MyString")
    credit_card_99.should_receive(:cvv).and_return("MyString")
    credit_card_99.should_receive(:street_address).and_return("MyString")
    credit_card_99.should_receive(:city).and_return("MyString")
    credit_card_99.should_receive(:state).and_return("MyString")
    credit_card_99.should_receive(:country).and_return("MyString")
    credit_card_99.should_receive(:zip).and_return("MyString")

    assigns[:credit_cards] = [credit_card_98, credit_card_99]
  end

  it "should render list of credit_cards" do
    render "/credit_cards/index.html.erb"
    response.should have_tag("tr>td", "MyString", 2)
    response.should have_tag("tr>td", "MyString", 2)
    response.should have_tag("tr>td", "MyString", 2)
    response.should have_tag("tr>td", "MyString", 2)
    response.should have_tag("tr>td", "MyString", 2)
    response.should have_tag("tr>td", "MyString", 2)
    response.should have_tag("tr>td", "MyString", 2)
    response.should have_tag("tr>td", "MyString", 2)
    response.should have_tag("tr>td", "MyString", 2)
    response.should have_tag("tr>td", "MyString", 2)
    response.should have_tag("tr>td", "MyString", 2)
  end
end

