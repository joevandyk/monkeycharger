class RemoveIvFromCard < ActiveRecord::Migration
  def self.up
    remove_column :credit_cards, :iv
  end

  def self.down
  end
end
