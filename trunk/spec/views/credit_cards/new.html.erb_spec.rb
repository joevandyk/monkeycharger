require File.dirname(__FILE__) + '/../../spec_helper'

describe "/credit_cards/new.html.erb" do
  include CreditCardsHelper
  
  before do
    @credit_card = mock_model(CreditCard)
    @credit_card.stub!(:new_record?).and_return(true)
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

  it "should render new form" do
    render "/credit_cards/new.html.erb"
    
    response.should have_tag("form[action=?][method=post]", credit_cards_path) do
      with_tag("input#credit_card_name[name=?]", "credit_card[name]")
      with_tag("input#credit_card_number[name=?]", "credit_card[number]")
      with_tag("input#credit_card_card_type[name=?]", "credit_card[card_type]")
      with_tag("input#credit_card_month[name=?]", "credit_card[month]")
      with_tag("input#credit_card_year[name=?]", "credit_card[year]")
      with_tag("input#credit_card_cvv[name=?]", "credit_card[cvv]")
      with_tag("input#credit_card_street_address[name=?]", "credit_card[street_address]")
      with_tag("input#credit_card_city[name=?]", "credit_card[city]")
      with_tag("input#credit_card_state[name=?]", "credit_card[state]")
      with_tag("input#credit_card_country[name=?]", "credit_card[country]")
      with_tag("input#credit_card_zip[name=?]", "credit_card[zip]")
    end
  end
end


