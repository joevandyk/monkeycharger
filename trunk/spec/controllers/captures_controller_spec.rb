require File.dirname(__FILE__) + '/../spec_helper'

describe "Capturing with a valid transaction id" do
   controller_name :captures
   before(:each) do
      @transaction_id = 'transactionid'
      Capture.should_receive(:capture!).with(@transaction_id).and_return(true)
      post :create, :transaction_id => @transaction_id
   end

   it "the response should be a success" do
      response.should be_success
   end

   it "should have the X-CaptureSuccess header set" do
      response.headers['X-CaptureSuccess'].should be_true
   end
end

describe "Capturing with a invalid transaction id" do
   controller_name :captures
   before(:each) do
      @transaction_id = 'transactionid'
      @failure_reason = "Because you touch yourself at night"
      Capture.should_receive(:capture!).with(@transaction_id).and_raise(CaptureError.new(@failure_reason))
      post :create, :transaction_id => @transaction_id
   end

   it "the response should be a success" do
      response.should be_success
   end

   it "should not have the X-CaptureSuccess header set" do
      response.headers['X-CaptureSuccess'].should_not be_true
   end

   it "the response's body should be equal to the reason why the capture failed" do
      response.body.should == @failure_reason
   end

end

describe CapturesController do
   it "should have routes for capturing" do
      assert_routing('/captures', {:controller => 'captures', :action => 'create'} )
   end
end
