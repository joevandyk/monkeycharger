class CreditCard < ActiveRecord::Base
   include ActiveMerchant::Billing::CreditCardMethods
   include ActiveMerchant::Billing::CreditCardMethods::ClassMethods

   attr_accessor :cvv, :number, :remote_key

   validates_presence_of :name, :street_address, :state, :zip, :country, :number, :city

   validate :check_for_credit_card_validity
   validate :month_and_year_should_be_in_future
   validate :at_least_two_words_in_name
   has_many :authorizations
   has_many :captures

   before_create :crypt_number

   # I need a better name for this method.  It's being used by the Authorizations's Controller.
   # Essentially, if I'm authorizing a saved card, I need to search for it, then decrypt it
   # using the remote key.
   # Otherwise, I'm just creating a new credit card using the params given to me.
   def self.prepare_for_authorization params
      if credit_card_id = params[:credit_card_id]
         find(credit_card_id).decrypt!(params[:remote_key])
      else
         new(params)
      end
   end

   # if there's a crypted number, decrypt it, otherwise, use the @number instance var
   def number(remote_key=nil)
      @number ||= decrypt_number(remote_key)
   end

   def decrypt!(remote_key)
      number(remote_key)
      self
   end

   # Gets the first name from name
   def first_name
      name.split[0] if name
   end

   # Gets the last name from name
   def last_name
      name.split[1..-1].join(" ") if name
   end

   # I forgot why I added this -- I'm sure there was a good reason.  Something to do with ActiveMerchant.
   alias verification_value? cvv
   alias verification_value verification_value?

   private

   def check_for_credit_card_validity
      errors.add(:year, "is not a valid year") unless valid_expiry_year?(year.to_i)
      errors.add(:month, "is not a valid month") unless valid_month?(month.to_i)
      errors.add(:number, "is not a valid credit card number") unless valid_number?(number)
      self.card_type = type?(number)
      errors.add_to_base("We only accept Visa and MasterCard.") unless self.card_type == 'master' or self.card_type == 'visa'
   end

   def month_and_year_should_be_in_future
      if (Date.new(year.to_i, month.to_i, 1) >> 1) < Date.today
         errors.add_to_base("The expiration date must be in the future.") and return false
      end
   rescue ArgumentError => e
      errors.add_to_base("Date is not valid") and return false
   end

   def at_least_two_words_in_name
      errors.add(:name, "must be two words long.") and return false if name and name.split.size < 2
   end

   # Encrypts the credit card number
   def crypt_number
      c = cipher
      c.encrypt
      c.key = key 
      c.iv = self.iv = generate_iv(remote_key)
      temp_number = c.update(number)
      temp_number << c.final
      self.crypted_number = encode_into_base64(temp_number) 
   end

   # Decrypts the credit card number
   def decrypt_number(remote_key)
      c = cipher
      c.decrypt
      c.key = key
      c.iv = generate_iv(remote_key)
      d = c.update(decode_from_base64(self.crypted_number))
      d << c.final
   end

   def cipher
      OpenSSL::Cipher::Cipher.new("aes-256-cbc")
   end

   def key
      Digest::SHA256.digest(@@CreditCardSecretKey)
   end

   def generate_iv(remote_key)
      raise ArgumentError.new("be sure to set the remote key") if remote_key.blank?
      encode_into_base64(Digest::SHA1.hexdigest(remote_key))
   end

   # Chomping is necessary for postgresql
   def encode_into_base64 string
      Base64.encode64(string).chomp
   end

   def decode_from_base64 string
      Base64.decode64(string)
   end
end
