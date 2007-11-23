class AuthorizationsController < ApplicationController
  def create
    @authorization = Authorization.new params[:authorization]
    if @authorization.save
      logger.info @authorization.to_xml
      render :xml => @authorization.to_xml, :status => :created, :location => @authorization
    else
      render :xml => @authorization.errors.to_xml, :status => :unprocessable_entity
    end
  end
end
