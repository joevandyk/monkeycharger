class AddTablesForCaptureRefundVoidAndAuthorizations < ActiveRecord::Migration
  def self.up

    create_table :authorizations do |t|
      t.column :credit_card_id, :integer
      t.column :transaction_id, :integer, :null => false
      t.column :last_four_digits, :string, :null => false      
      t.column :amount, :decimal, :null => false
      t.timestamps
    end

    create_table :captures do |t|
      t.column :authorization_id, :integer, :null => false
      t.column :transaction_id, :integer, :null => false
      t.column :amount, :integer, :null => false
      t.timestamps
    end

    create_table :refunds do |t|
      t.column :authorization,  :integer,  :null => false
      t.column :transaction_id, :integer,  :null => false
      t.column :amount, :decimal, :null => false
      t.timestamps
    end

    create_table :voids do |t|
      t.column :voidee_id, :integer,:null => false
      t.column :voidee_type, :string, :null => false
      t.column :transaction_id, :integer,  :null => false
      t.timestamps
    end

  end

  def self.down
    drop_table :captures
    drop_table :refunds
    drop_table :voids
    drop_table :authorizations
  end
end
