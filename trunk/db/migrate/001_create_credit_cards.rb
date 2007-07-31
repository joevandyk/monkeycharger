class CreateCreditCards < ActiveRecord::Migration
  def self.up
    create_table :credit_cards do |t|
      t.string :name, :null => false
      t.string :number, :null => false
      t.string :card_type, :null => false
      t.string :month, :null => false
      t.string :year, :null => false
      t.string :cvv, :null => false
      t.string :street_address, :null => false
      t.string :city, :null => false
      t.string :state, :null => false
      t.string :country, :null => false
      t.string :zip, :null => false

      t.timestamps 
    end
  end

  def self.down
    drop_table :credit_cards
  end
end
