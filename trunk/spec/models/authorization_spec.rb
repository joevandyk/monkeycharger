require File.dirname(__FILE__) + '/../spec_helper'

describe Authorizer, "a non-saved card" do
   before(:each) do
      @salt = '12345'
      @credit_card = generate_credit_card
      @amt = BigDecimal.new '5.99'
   end

   it "the gateway should receive the authorization" do
      $gateway.should_receive(:authorize).with(@amt, @credit_card).and_return(successful_authorization)
      Authorization.create! :credit_card_id => @credit_card.id, :amount => @amt, :remote_salt => @salt
   end

   it "shouldn't save on an unsuccessful authorization" do
      $gateway.should_receive(:authorize).with(@amt, @credit_card).and_return(unsuccessful_authorization)
      auth = Authorization.new :credit_card_id => @credit_card.id, :amount => @amt, :remote_salt => @salt
      auth.save.should_not be_true
   end

   private

   def successful_authorization
      stub(Object, :success? => true, :authorization => '1234')
   end

   def unsuccessful_authorization
      stub(Object, :success? => false, :message => 'reason why it failed')
   end
end

