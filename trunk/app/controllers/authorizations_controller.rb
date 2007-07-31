class AuthorizationsController < ApplicationController
  def create
     @credit_card   = Authorizer.prepare_credit_card_for_authorization(params)
     transaction_id = Authorizer::authorize!(:amount => params[:amount], :credit_card => @credit_card)
     response.headers['X-AuthorizationSuccess'] = true
     render :text => transaction_id
  rescue AuthorizationError => e
     render :text => e.message
  end
end
