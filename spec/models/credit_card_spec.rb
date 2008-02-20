require File.dirname(__FILE__) + '/../spec_helper'

include CreditCardsHelper

describe CreditCard, "a valid credit card" do
   before(:each) do
      @number = 4242424242424242
      @passphrase = '12345'
      @credit_card = generate_credit_card :number => @number, :passphrase => '12345'
   end

   it "should save the last four digits" do
      @credit_card.last_four_digits.should == '4242'
   end

   it "the number should be able to be decrypted" do
      card = CreditCard.find(@credit_card)
      card.decrypt!(@passphrase)
      card.number.should == @number.to_s
   end

   it "the number shouldn't be able to be decrypted if the secret key is wrong" do
      @@CreditCardSecretKey = "asdf"
      card = CreditCard.find(@credit_card.id)
      lambda { card.decrypt!(@passphrase) }.should raise_error(Exception)
   end
   
   it "the number shouldn't be able to be decrypted if the remote key is wrong" do
      card = CreditCard.find(@credit_card.id)
      lambda { card.decrypt!(@eemote_key.reverse) }.should raise_error(Exception)
   end

end

describe CreditCard do
   it "should have a valid month" do
      generate_credit_card(:month => 'f').errors.on(:month).should == "is not a valid month"
   end

   it "should have a valid year" do
      generate_credit_card(:year => 'asdf').errors.on(:year).should == "is not a valid year"
   end

   it "date should not be in the past" do
      past_month = (Date.today << 2)
      generate_credit_card(:year => past_month.year, :month => past_month.month).should_not be_valid
   end

   it "should have at least one word in the name" do
      generate_credit_card(:name => "Sam").should be_valid
   end

   it "should have two words in the last name if the name is three words long" do
      generate_credit_card(:name => "Sam Van Dyk").last_name.should == "Van Dyk"
   end

   it "should have one word in the first name if the name is three words long" do
      generate_credit_card(:name => "Sam Van Dyk").first_name.should == "Sam"
   end

   it "should have a blank last name if the name is one word long" do
      card = generate_credit_card(:name => "Sam")
      card.first_name.should == "Sam"
      card.last_name.should be_blank
   end

end

describe "We only take Visa and MasterCard" do
   before(:each) do
      @amex_card = generate_credit_card(:number => '341234567890123')
      @discover_card = generate_credit_card(:number => '60111234567890123456')
   end
   it "should not accept amex" do 
      check_only_accept_visa_and_master_error(@amex_card)
   end

   it "should not accept discover" do
      check_only_accept_visa_and_master_error(@discover_card)
   end

   def check_only_accept_visa_and_master_error card
      card.errors.full_messages.should be_include("We only accept Visa and MasterCard.")
   end
end


describe "Editing a saved credit card" do
  before(:each) do
    # Generate the original card
    @card = generate_credit_card(:number => "4111111111111111")
    # Find and edit the number
    @card = CreditCard.find @card.id
    @card.number = "4242424242424242"
    @card.passphrase = DEFAULT_TEST_PASS
    @card.save!
  end

  it "should update the last four digits" do
    @card.last_four_digits.should == "4242"
  end
  
  it "should update the number with th enew number" do
    @card.number.should == '4242424242424242'
  end 
end

describe "A saved credit card" do
  before(:each) do
    @number = "4111111111111111"
    @card = generate_credit_card(:number => @number)
  end
  
  it "an attacker should not be able to decrypt the card number without a passphrase" do
    card = CreditCard.find @card.id
    
    cipher = card.send(:cipher)
    cipher.decrypt
    cipher.key = card.send(:key)
    # cipher.iv = card.iv  NOTE: iv no longer stupidly stored
    cipher.iv = "some random one that shouldn't work"
    data = cipher.update(card.send(:decode_from_base64, card.crypted_number))
    data << cipher.final
    data.should_not == @number
  end
end
