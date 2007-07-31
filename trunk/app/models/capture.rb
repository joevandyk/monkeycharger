class CaptureError < StandardError; end
class Capture 
   def self.capture! transaction_id
      response = $gateway.capture(transaction_id)
      if response.success?
         true
      else
         raise CaptureError.new(response.message)
      end
   end
end
