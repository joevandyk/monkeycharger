class CreditCard < ActiveRecord::Base
   include ActiveMerchant::Billing::CreditCardMethods
   include ActiveMerchant::Billing::CreditCardMethods::ClassMethods

   attr_accessor :cvv, :number

   validates_presence_of :name, :street_address, :state, :zip, :country, :number, :city

   validate :check_for_credit_card_validity
   validate :month_and_year_should_be_in_future
   validate :at_least_two_words_in_name
   has_many :authorizations
   has_many :captures

   before_create :crypt_number

   # if there's a crypted number, decrypt it, otherwise, use the @number instance var
   def number
      @number ||= decrypt_number
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
      c.iv = generate_iv 
      temp_number = c.update(number)
      temp_number << c.final
      self.crypted_number = Base64.encode64(temp_number).chomp # the chomp is necessary to insert it into postgres correctly
   end

   # Decrypts the credit card number
   def decrypt_number
      c = cipher
      c.decrypt
      c.key = key
      c.iv = iv
      d = c.update(Base64.decode64(self.crypted_number))
      d << c.final
   end

   def cipher
      OpenSSL::Cipher::Cipher.new("aes-256-cbc")
   end

   def key
      Digest::SHA256.digest(@@CreditCardSecretKey)
   end

   def generate_iv
      self.iv = Base64.encode64(cipher.random_iv).chomp # The chomp is necessary to insert it into postgres correctly
   end
end
