require File.dirname(__FILE__) + '/../spec_helper'

describe "Capturing with a valid transaction id" do
   before(:each) do
     auth_transaction_id = 'auth-trans-id'
     @authorization = mock_model(Authorization, :transaction_id => auth_transaction_id)
     @amount = BigDecimal.new("2")
     $gateway.should_receive(:capture).with(@amount, auth_transaction_id).and_return(successful_capture)
   end

   it "should satisfy expectations" do
     Capture.create!(:amount => @amount, :authorization => @authorization)
   end

end

describe Capture, "Capturing with an invalid transaction id" do
   before(:each) do
     auth_transaction_id = 'auth-trans-id'
     @authorization = mock_model(Authorization, :transaction_id => auth_transaction_id)
     @amount = BigDecimal.new "3"
     $gateway.should_receive(:capture).with(@amount, auth_transaction_id).and_return(unsuccessful_capture)
   end

   it "should satisfy expecations" do
     capture = Capture.create(:amount => @amount, :authorization => @authorization)
     capture.should be_new_record
     capture.errors.full_messages.should == [unsuccessful_capture.message]
   end
end


   def successful_capture
      stub(Object, :success? => true, :authorization => 'authid')
   end

   def unsuccessful_capture
      stub(Object, :success? => false, :message => 'reason why it failed')
   end
