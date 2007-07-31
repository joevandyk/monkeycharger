class AuthorizationsController < ApplicationController
  def create
     @credit_card = 
        if params[:credit_card_id]  # We're charging an existing card
           CreditCard.find params[:credit_card_id] 
        else                        # We're charging a new card.  (not gonna save it though)
           CreditCard.new(:number => params[:number], :cvv => params[:cvv], :month => params[:month], :year => params[:year])
        end
     @credit_card.decrypt(params[:remote_key])
     transaction_id =  Authorizer::authorize!(:amount => params[:amount], :credit_card => @credit_card)
     response.headers['X-AuthorizationSuccess'] = true
     render :text => transaction_id
  rescue AuthorizationError => e
     render :text => e.message
  end
end
