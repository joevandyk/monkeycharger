class RefundsController < ApplicationController
  def create
    @authorization = Authorization.find params[:authorization]
    @refund = Refund.new :amount => params[:amount], :authorization => @authorization
    if @refund.save
      render :xml => @refund.to_xml, :status => :created, :location => @void
    else
      render :xml => @refund.errors.to_xml, :status => :unprocessable_entity
    end
  end
end
