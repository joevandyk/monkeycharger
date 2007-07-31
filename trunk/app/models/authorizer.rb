class AuthorizationError < StandardError; end

module Authorizer
   def self.authorize! options
      amount = options[:amount].to_f * 100
      card   = options[:credit_card]
      response = $gateway.authorize(amount, card)
         puts response.inspect
      if response.success?
         return response.authorization
      else
         raise AuthorizationError.new(response.message)
      end
   end
end
