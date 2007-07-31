class Capture 
   def self.capture! amount, transaction_id
      amount = (amount.to_f * 100).to_i
      response = $gateway.capture(amount, transaction_id)
      raise CaptureError.new(response.message) unless response.success?
   end
end
