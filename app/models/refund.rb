class Refund < ActiveRecord::Base
  belongs_to :authorization
  has_one :void, :as => :voidee
  validates_presence_of :amount
  validates_presence_of :authorization
  before_create :refund!

  private

  # Does the refund against the gateway
  def refund!
    response = $gateway.credit(self.amount, authorization.transaction_id, :card_number => authorization.last_four_digits )
    if response.success?
      self.transaction_id = response.authorization
    else
      errors.add_to_base response.message
      return false
    end
  end

end
