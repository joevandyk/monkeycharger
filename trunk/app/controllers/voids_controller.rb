class VoidsController < ApplicationController
  def create
    @void = Void.new params[:void]
    if @void.save
      render :xml => @void.to_xml, :status => :created
    else
      render :xml => @void.errors.to_xml, :status => :unprocessable_entity
    end
  end
end
