require File.dirname(__FILE__) + '/../spec_helper'

describe Authorizer, "a non-saved card" do
   before(:each) do
      @credit_card = CreditCard.new(:number => '4111111111111111', :year => 2009, :month => 9, :name => 'Joe Van Dyk', :cvv => '123')
   end

   it "the gateway should receive the authorization" do
      $gateway.should_receive(:authorize).with(599, @credit_card).and_return(successful_authorization)
      Authorizer::authorize!(:credit_card => @credit_card, :amount => '5.99')
   end

   it "authorize! should return the transaction id" do
      $gateway.should_receive(:authorize).with(599, @credit_card).and_return(successful_authorization)
      Authorizer::authorize!(:credit_card => @credit_card, :amount => '5.99').should == successful_authorization.authorization
   end

   it "authorize! should throw an exception on a unsuccessful authorization" do
      $gateway.should_receive(:authorize).with(599, @credit_card).and_return(unsuccessful_authorization)
      lambda { Authorizer::authorize!(:credit_card => @credit_card, :amount => '5.99') }.should raise_error(AuthorizationError, unsuccessful_authorization.message)
   end

   private

   def successful_authorization
      stub(Object, :success? => true, :authorization => '1234')
   end

   def unsuccessful_authorization
      stub(Object, :success? => false, :message => 'reason why it failed')
   end
end

