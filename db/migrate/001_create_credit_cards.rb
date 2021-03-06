class CreateCreditCards < ActiveRecord::Migration
  def self.up
    create_table :credit_cards do |t|
      t.string :name, :null => false
      t.string :crypted_number, :null => false
      t.string :last_four_digits, :null => false
      t.string :iv, :null => false
      t.string :card_type, :null => false
      t.string :month, :null => false
      t.string :year, :null => false
      t.string :street_address
      t.string :city
      t.string :state
      t.string :country
      t.string :zip

      t.timestamps 
    end
  end

  def self.down
    drop_table :credit_cards
  end
end
