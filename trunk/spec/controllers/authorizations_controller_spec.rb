require File.dirname(__FILE__) + '/../spec_helper'

describe AuthorizationsController, "authorizing a non-saved card" do
   fixtures :credit_cards
   before(:each) do
      @credit_card = CreditCard.new(:number => '4111111111111111', :month => '9', :year => '2009', :cvv => '123')
      CreditCard.should_receive(:new).with(:number => @credit_card.number, :month => @credit_card.month, :year => @credit_card.year, :cvv => @credit_card.cvv).and_return(@credit_card)
      Authorizer.should_receive(:authorize!).with({:credit_card => @credit_card, :amount => '3.99'}).and_return('authid')
      post :create, :amount => '3.99', :number => @credit_card.number, :cvv => @credit_card.cvv, :month => @credit_card.month, :year => @credit_card.year
   end

   it "the body of the response should be set to the authorization id " do
      response.body.should == 'authid'
   end

   it "should be a success" do
      response.should be_success
   end

end

describe "A successful authorization of a saved card" do
   controller_name :authorizations
   fixtures :credit_cards
   before(:each) do
      @credit_card = credit_cards(:saved_card)
      CreditCard.should_receive(:find).with(@credit_card.id.to_s).and_return(@credit_card)
      Authorizer.should_receive(:authorize!).with(:amount => '3.99', :credit_card => @credit_card).and_return('authid')
      post :create, :amount => '3.99', :credit_card_id => @credit_card.id
   end

   it "the AuthorizationSuccess header should be set" do
      response.headers['X-AuthorizationSuccess'].should be_true
   end

   it "should be a success" do
      response.should be_success
   end

   it "the body of the response should be set to the authorization id" do
      response.body.should == 'authid'
   end
end

describe "A failed authorization of a saved card" do
   controller_name :authorizations
   fixtures :credit_cards
   before(:each) do
      @credit_card = credit_cards(:saved_card)
      CreditCard.should_receive(:find).with(@credit_card.id.to_s).and_return(@credit_card)
      Authorizer.should_receive(:authorize!).with(:amount => '3.99', :credit_card => @credit_card).and_raise(AuthorizationError.new("problem!"))
      post :create, :amount => '3.99', :credit_card_id => @credit_card.id
   end

   it "should not set the AuthorizationSuccess header" do
      response.headers['X-AuthorizationSuccess'].should_not be_true
   end

   it "the body of the response should be set to the reason why the authorization failed" do
      response.body.should == 'problem!'
   end

   it "the response should be a success" do
      response.should be_success
   end
end

describe AuthorizationsController do
   it "should have routes for authorizing" do
      assert_routing('/authorizations', {:controller => 'authorizations', :action => 'create'} )
   end
end
