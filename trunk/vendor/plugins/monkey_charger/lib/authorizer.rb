class BillingError < StandardError; end

class Authorizer
   SITE = "http://localhost:3001/authorizations"
   # amount is the amount to charge
   # set :credit_card_id to charge a saved credit card OR
   # set :number, :month, :year, :cvv, etc to charge a new card
   # example: authorize!('3.99', :credit_card_id => 1
   # example: authorize!(5, :number => '4111111111111111', :cvv => '123', :month => 9, :year => 2009
   def self.authorize! amount, credit_card_options={}
      response = Net::HTTP.post_form(URI.parse(SITE), { :amount => amount }.merge(credit_card_options))
      case response
      when Net::HTTPSuccess
         if response.header['X-AuthorizationSuccess'] 
            return response.body
         else
            raise BillingError, response.body
         end
      else
         raise response.body
      end
   end
end
