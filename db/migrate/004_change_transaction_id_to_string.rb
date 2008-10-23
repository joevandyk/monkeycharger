class ChangeTransactionIdToString < ActiveRecord::Migration
  def self.up
    change_column :authorizations, :transaction_id, :string
    change_column :captures,       :transaction_id, :string
    change_column :refunds,        :transaction_id, :string
    change_column :voids,          :transaction_id, :string
  end

  def self.down
  end
end
