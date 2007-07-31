class CreditCard < ActiveRecord::Base

   validate :check_for_credit_card_validity
   validate :month_and_year_should_be_in_future
   validate :at_least_two_words_in_name
   has_many :authorizations
   has_many :captures
   validates_presence_of :name, :street_address, :state, :zip, :country, :number, :cvv, :card_type, :city

   def first_name
      name.split[0] if name
   end

   def last_name
      name.split[1..-1].join(" ") if name
   end

   def verification_value?
      cvv
   end

   def authorize amount, ip
      authorizations.create :amount => amount, :credit_card => self, :ip => ip
   end

   alias verification_value verification_value?

   private

   def check_for_credit_card_validity
      errors.add(:year, "is not a valid year") unless valid_expiry_year?(year.to_i)
      errors.add(:month, "is not a valid month") unless valid_month?(month.to_i)
      errors.add(:number, "is not a valid credit card number") unless valid_number?(number)
      errors.add_to_base("We only accept Visa and MasterCard.") unless type?(number) == 'master' or type?(number) == 'visa'
      self.card_type = type?(number)
      logger.info type?(number)
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

end
