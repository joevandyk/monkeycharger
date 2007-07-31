require File.dirname(__FILE__) + '/../../spec_helper'

describe "/credit_cards/show.html.erb" do
  include CreditCardsHelper
  
  before do
    @credit_card = mock_model(CreditCard)
    @credit_card.stub!(:name).and_return("MyString")
    @credit_card.stub!(:number).and_return("MyString")
    @credit_card.stub!(:card_type).and_return("MyString")
    @credit_card.stub!(:month).and_return("MyString")
    @credit_card.stub!(:year).and_return("MyString")
    @credit_card.stub!(:cvv).and_return("MyString")
    @credit_card.stub!(:street_address).and_return("MyString")
    @credit_card.stub!(:city).and_return("MyString")
    @credit_card.stub!(:state).and_return("MyString")
    @credit_card.stub!(:country).and_return("MyString")
    @credit_card.stub!(:zip).and_return("MyString")

    assigns[:credit_card] = @credit_card
  end

  it "should render attributes in <p>" do
    render "/credit_cards/show.html.erb"
    response.should have_text(/MyString/)
    response.should have_text(/MyString/)
    response.should have_text(/MyString/)
    response.should have_text(/MyString/)
    response.should have_text(/MyString/)
    response.should have_text(/MyString/)
    response.should have_text(/MyString/)
    response.should have_text(/MyString/)
    response.should have_text(/MyString/)
    response.should have_text(/MyString/)
    response.should have_text(/MyString/)
  end
end

