class AuthorizationsController < ApplicationController
  def create
     @credit_card = 
        if params[:credit_card_id]
           CreditCard.find params[:credit_card_id] 
        else
           CreditCard.new(:number => params[:number], :cvv => params[:cvv], :month => params[:month], :year => params[:year])
        end
     transaction_id =  Authorizer::authorize!(:amount => params[:amount], :credit_card => @credit_card)
     response.headers['X-AuthorizationSuccess'] = true
     render :text => transaction_id
  rescue AuthorizationError => e
     render :text => e.message
  end
end
