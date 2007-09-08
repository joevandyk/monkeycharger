class CapturesController < ApplicationController
  def create
    @authorization = Authorization.find params[:authorization]
    @capture = Capture.new :amount => params[:amount], :authorization => @authorization
    if @capture.save
      render :xml => @capture.to_xml, :status => :created, :location => @capture
    else
      render :xml => @capture.errors.to_xml, :status => :unprocessable_entity
    end
  end
end
