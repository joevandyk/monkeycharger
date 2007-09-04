class Authorization < ActiveRecord::Base
  attr_accessor :remote_salt

  has_many    :refunds
  has_one     :capture
  has_one     :void, :as => :voidee
  belongs_to  :credit_card

  validate :authorize!

  validates_presence_of :transaction_id
  validates_presence_of :remote_salt
  validates_presence_of :last_four_digits

  
  def initialize attributes
    super(attributes)
    # Do an authorization on an existing credit card
    if credit_card_id = attributes[:credit_card_id]
      self.credit_card = CreditCard.find(credit_card_id).decrypt!(attributes[:remote_salt])
    else
    # Do an authorization on a credit card that isn't saved
      self.credit_card = CreditCard.new(:number => attributes[:number], :cvv => attributes[:cvv], :month => attributes[:month], :year => attributes[:year], :name => attributes[:name])
    end
  end

  private

  def authorize! 
    response = $gateway.authorize(self.amount, self.credit_card)
    if response.success?
      self.transaction_id = response.authorization
      self.last_four_digits = self.credit_card.last_four_digits
    else
      errors.add_to_base(response.message)
      return false
    end
  end
end
