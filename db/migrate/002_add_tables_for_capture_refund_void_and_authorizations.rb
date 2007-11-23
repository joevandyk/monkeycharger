class AddTablesForCaptureRefundVoidAndAuthorizations < ActiveRecord::Migration
  def self.up

    create_table :authorizations do |t|
      integer     :credit_card_id
      integer     :transaction_id,  :null => false
      string      :last_four_digits, :null => false
      decimal     :amount,          :null => false
      timestamps!
    end

    create_table :captures do |t|
      foreign_key :authorization, :ref => true
      integer     :transaction_id, :null => false
      decimal     :amount, :null => false
      timestamps!
    end

    create_table :refunds do |t|
      foreign_key :authorization,   :ref => true
      integer     :transaction_id,  :null => false
      decimal     :amount,          :null => false
      timestamps!
    end

    create_table :voids do |t|
      integer :voidee_id,       :null => false
      string  :voidee_type,     :null => false
      integer :transaction_id,  :null => false
      timestamps!
    end

  end

  def self.down
    drop_table :captures
    drop_table :refunds
    drop_table :voids
    drop_table :authorizations
  end
end
