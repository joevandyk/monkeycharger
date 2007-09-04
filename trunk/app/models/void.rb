class Void < ActiveRecord::Base
  belongs_to :voidee, :polymorphic => true
  validates_presence_of :voidee

  before_create :void!

  private

  def void!
    response = $gateway.void(voidee.transaction_id)
    if response.success?
      self.transaction_id = response.authorization
    else
      errors.add_to_base response.message
      return false
    end
  end
end
