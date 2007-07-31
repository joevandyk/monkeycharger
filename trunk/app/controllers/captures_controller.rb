class CapturesController < ApplicationController
  def create
     Capture::capture!(params[:amount], params[:transaction_id])
     response.headers["X-CaptureSuccess"] = true
     render :text => 'ok'
  rescue CaptureError => e
     render :text => e.message
  end
end
