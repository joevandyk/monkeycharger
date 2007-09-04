class AuthorizationsController < ApplicationController
  def create
    @authorization = Authorization.new params[:authorization]
    if @authorization.save
      render :xml => @authorization.to_xml, :status => :created
    else
      render :xml => @authorization.errors.to_xml, :status => :unprocessable_entity
    end
  end
end
