
module Authorizer
   def self.prepare_credit_card_for_authorization params
      if credit_card_id = params[:credit_card_id]
         CreditCard.find(credit_card_id).decrypt!(params[:remote_key])
      else
         CreditCard.new(params)
      end
   end

   def self.authorize! options
      amount = (options[:amount].to_f * 100).to_i
      card   = options[:credit_card]
      response = $gateway.authorize(amount, card)
      if response.success?
         return response.authorization
      else
         raise AuthorizationError.new(response.message)
      end
   end
end
