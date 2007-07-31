require File.dirname(__FILE__) + '/../spec_helper'

describe AuthorizationsController, "authorizing a non-saved card" do
   before(:each) do
      @auth_id = 'authid'
      @credit_card = CreditCard.new(valid_cc_data)
      remote_key = '12345'
      Authorizer.should_receive(:prepare_credit_card_for_authorization).and_return(@credit_card)
      Authorizer.should_receive(:authorize!).with({:credit_card => @credit_card, :amount => '3.99'}).and_return(@auth_id)
      post_parameters = {:amount => '3.99', :remote_key => '12345'}.merge(valid_cc_data)
      post :create, post_parameters
   end

   it "the body of the response should be set to the authorization id " do
      response.body.should == @auth_id
   end

   it "the response should be a success" do
      response.should be_success
   end

   def valid_cc_data
      { :number => '4111111111111111',
        :month => '9',
        :year => (Time.now.year + 1).to_s,
        :cvv => '123' }
   end
end

describe "A successful authorization of a saved card" do
   controller_name :authorizations
   before(:each) do
      @credit_card = generate_credit_card
      Authorizer.should_receive(:prepare_credit_card_for_authorization).and_return(@credit_card)
      @auth_id = 'auth_id'
      remote_key = '12345'
      Authorizer.should_receive(:authorize!).with(:amount => '3.99', :credit_card => @credit_card).and_return(@auth_id)
      post :create, :amount => '3.99', :credit_card_id => @credit_card.id, :remote_key => remote_key
   end

   it "the AuthorizationSuccess header should be set" do
      response.headers['X-AuthorizationSuccess'].should be_true
   end

   it "the response should be a success" do
      response.should be_success
   end

   it "the response's body  should be set to the authorization id" do
      response.body.should == @auth_id
   end
end

describe "A failed authorization of a saved card" do
   controller_name :authorizations
   before(:each) do
      remote_key = '12345'
      @credit_card = generate_credit_card(:remote_key => remote_key)
      CreditCard.should_receive(:find).with(@credit_card.id.to_s).and_return(@credit_card)
      Authorizer.should_receive(:authorize!).with(:amount => '3.99', :credit_card => @credit_card).and_raise(AuthorizationError.new("problem!"))
      post :create, :amount => '3.99', :credit_card_id => @credit_card.id, :remote_key => remote_key
   end

   it "should not set the AuthorizationSuccess header" do
      response.headers['X-AuthorizationSuccess'].should_not be_true
   end

   it "the response's body  should be set to the reason why the authorization failed" do
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
