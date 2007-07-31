class Capturer
   SITE = "http://localhost:3001/captures"
   def self.capture! transaction_id
      response = Net::HTTP.post_form URI.parse(SITE), :transaction_id => transaction_id 
      case response
      when Net::HTTPSuccess
         raise BillingError, response.body unless response.header['X-CaptureSuccess'] 
      else
         raise response.body
      end
   end
end
