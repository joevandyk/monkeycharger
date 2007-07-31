
module Authorizer
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
