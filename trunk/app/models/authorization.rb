class Authorization < ActiveRecord::Base
  attr_accessor :passphrase

  has_many    :refunds
  has_one     :capture
  has_one     :void, :as => :voidee
  belongs_to  :credit_card

  validate :authorize!

  validates_presence_of :transaction_id
  validates_presence_of :last_four_digits

  after_validation :remove_other_error_messages
  
  def initialize attributes
    super(attributes)
    # Do an authorization on an existing credit card
    if credit_card_id = attributes[:credit_card_id]
      self.credit_card = CreditCard.find(credit_card_id).decrypt!(attributes[:passphrase])
    end
  end


  alias_method :set_credit_card_association, :credit_card=

  def credit_card= card
    if card.is_a?(Hash)
      card =  CreditCard.new(:number => card['number'], :month => card['month'], :year => card['year'], :name => card['name'])
      set_credit_card_association card
      self.last_four_digits = card.last_four_digits
    else
      set_credit_card_association card
    end
  end

  private

  def authorize! 
    response = $gateway.authorize(self.amount.to_cents, self.credit_card)
    if response.success?
      self.transaction_id = response.authorization
      self.last_four_digits = self.credit_card.last_four_digits
    else
      logger.info "Bad authorization!"
      logger.info response.message
      errors.add_to_base(response.message)
    end
  end

  # There might be a better way to do this, but I don't want ActiveRecord
  # adding error messages for when the transaction_id or last_four_digits
  # is missing as a result of a failed authorization.  The only error 
  # message should be from the credit card processor.
  def remove_other_error_messages
    base_error_msg = errors.on(:base)
    errors.clear
    errors.add_to_base(base_error_msg) if base_error_msg
  end
end
