class Capture < ActiveRecord::Base
  belongs_to :authorization
  validate :capture!
  validates_presence_of :authorization
  validates_presence_of :amount

  private

  def capture! 
    response = $gateway.capture(amount, authorization.transaction_id)
    if response.success?
      self.transaction_id = response.authorization
    else
      errors.add_to_base(response.message)
      return false
    end
  end
end
