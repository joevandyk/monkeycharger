require "test/test_helper"

class BigIntegrationTest < ActionController::IntegrationTest
  def random_purchase_amount
    (rand(10000) + 1).to_s
  end

   def test_the_happy_path
      passphrase = '12345'

      card = nil
      assert_difference "CreditCard.count" do
         card = create_credit_card(:passphrase => passphrase)
      end
      assert_response :created

      amount = random_purchase_amount
      assert_difference 'Authorization.count' do
        authorize_existing_card(amount, card, passphrase)
      end
      assert_response :created
      authorization = assigns(:authorization)

      assert_difference 'Capture.count' do
        capture(amount, authorization)
      end
      assert_response :created
   end

   def test_authorizing_a_one_time_card
     card = valid_cc_attributes
     assert_difference 'Authorization.count' do
       authorize_one_time_card random_purchase_amount,  card
       assert_response :created
     end
   end

   def test_storing_a_bad_card
      card = nil
      assert_no_difference "CreditCard.count" do
        card = create_credit_card(:number => 'oh crap')
      end
       assert card.errors.on(:number)
   end

   def test_cant_create_card_with_no_salt_supplied
     card = create_credit_card(:passphrase => '')
     assert_equal card.errors.on(:passphrase), "can't be blank"
     card = create_credit_card(:passphrase => nil)
     assert_equal card.errors.on(:passphrase), "can't be blank"
   end

   def test_capturing_a_bad_amount_should_fail
      passphrase = '12345'
      card = create_credit_card(:passphrase => passphrase)
      amount = random_purchase_amount
      transaction_id = authorize_existing_card(amount, card, passphrase)
      capture(amount.to_i + 1, transaction_id)  # trying to capture with an amount too high
      assert response.headers["X-CaptureSuccess"] != true
   end

   def test_authorizing_with_bad_passphrase_should_suck
      amount = random_purchase_amount
      passphrase = '12345'
      bad_passphrase = '54321'
      card = create_credit_card(:passphrase => passphrase)

      assert_no_difference 'Authorization.count' do
        authorize_existing_card(amount, card, bad_passphrase)
      end
   end

   def test_voiding_an_authorized_order
     card = create_credit_card
     amount = random_purchase_amount
     authorization = authorize_existing_card(amount, card)
     assert_difference 'Void.count' do
       void(authorization)
     end
   end

   def test_voiding_a_refund
     card = create_credit_card
     amount = random_purchase_amount
     authorization = authorize_existing_card(amount, card)
     capture(amount, authorization)
     # TODO not sure how to test a refund, other than mocking out the calls to $gateway
     #assert_difference 'Refund.count' do
       #refund = refund(amount, authorization)
     #end
     #assert_difference 'Void.count' do
       #void(refund) 
     #end
   end

   private

   def valid_cc_attributes
      { :number         => '4242424242424242', 
        :cvv            => '123',
        :year           => Time.now.year + 1, 
        :month          => Time.now.month, 
        :name           => "Joe Van Dyk", 
        :street_address => "123 Main",
        :city           => "Seattle",
        :state          => "WA",
        :zip            => "98115", 
        :country        => "USA",
        :passphrase     => 'blurb' }
   end

   def create_credit_card options={}
      card_values = valid_cc_attributes
      card_values.merge!(options)
      post credit_cards_url(:credit_card => card_values, :format => 'xml')
      assigns(:credit_card)
   end

   def authorize_existing_card amount, card, passphrase='blurb'
      post authorizations_url(:authorization => { :amount => amount, :credit_card_id => card.id, :passphrase => passphrase })
      assigns(:authorization)
   end

   def authorize_one_time_card amount, card
      post authorizations_url(:authorization => { :amount => amount, :credit_card => card })
      assigns(:authorization)
   end

   def capture amount, authorization
      post captures_url(:capture => {:amount => amount, :authorization => authorization})
      assigns(:capture)
   end

   def refund amount, authorization
      post refunds_url(:amount => amount, :authorization => authorization)
      assigns(:refund)
   end

   def void thing_to_void
     post voids_url(:void => { :voidee_type => thing_to_void.class, :voidee_id => thing_to_void})
     assigns(:void)
   end

end
