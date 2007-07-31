require File.dirname(__FILE__) + '/../spec_helper'

describe "Capturing with a valid transaction id" do
   before(:each) do
      @transaction_id = 'transaction_id'
      @amount = "2"
      $gateway.should_receive(:capture).with(200.0, @transaction_id).and_return(successful_capture)
   end

   it "capture! should not throw an exception" do
      Capture::capture!(@amount, @transaction_id).should_not raise_error(CaptureError)
   end

end

describe Capture, "Capturing with an invalid transaction id" do
   before(:each) do
      @transaction_id = 'transaction_id'
      @amount = "3"
      $gateway.should_receive(:capture).with(300.0, @transaction_id).and_return(unsuccessful_capture)
   end

   it "capture! should throw an exception on a unsuccessful capture" do
      lambda { Capture::capture!(@amount, @transaction_id ) }.should raise_error(CaptureError, unsuccessful_capture.message)
   end
end


   def successful_capture
      stub(Object, :success? => true)
   end

   def unsuccessful_capture
      stub(Object, :success? => false, :message => 'reason why it failed')
   end
