class CapturesController < ApplicationController
  def create
     Capture::capture!(params[:transaction_id])
     response.headers["X-CaptureSuccess"] = true
  rescue CaptureError => e
     render :text => e.message
  end
end
