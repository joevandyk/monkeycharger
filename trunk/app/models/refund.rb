class Refund < ActiveRecord::Base
  belongs_to :authorization
  has_one :void, :as => :voidee
  validates_presence_of :amount
  validates_presence_of :authorization
  before_create :refund!

  private

  # Does the refund against the gateway
  def refund!
    response = $gateway.credit(authorization.transaction_id)
    if response.success?
      self.transaction_id = response.authorization
    else
      errors.add_to_base response.message
      return false
    end
  end

end
