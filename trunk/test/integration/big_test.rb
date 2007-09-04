require "test/test_helper"

class BigIntegrationTest < ActionController::IntegrationTest
   def test_the_happy_path
      remote_salt = '12345'

      card = nil
      assert_difference "CreditCard.count" do
         card = create_credit_card(:remote_salt => remote_salt)
      end
      assert_response :created

      amount = (rand(1000) + 1).to_s
      assert_difference 'Authorization.count' do
        authorize_existing_card(amount, card, remote_salt)
      end
      assert_response :created
      authorization = assigns(:authorization)

      assert_difference 'Capture.count' do
        capture(amount, authorization)
      end
      assert_response :created
   end

   def test_storing_a_bad_card
      card = nil
      assert_no_difference "CreditCard.count" do
        card = create_credit_card(:number => 'oh crap')
      end
       assert card.errors.on(:number)
   end

   def test_cant_create_card_with_no_salt_supplied
     card = create_credit_card(:remote_salt => '')
     assert_equal card.errors.on(:remote_salt), "can't be blank"
     card = create_credit_card(:remote_salt => nil)
     assert_equal card.errors.on(:remote_salt), "can't be blank"
   end

   def test_capturing_a_bad_amount_should_fail
      remote_salt = '12345'
      card = create_credit_card(:remote_salt => remote_salt)
      amount = rand(1000).to_s
      transaction_id = authorize_existing_card(amount, card, remote_salt)
      capture(amount.to_i + 1, transaction_id)  # trying to capture with an amount too high
      assert response.headers["X-CaptureSuccess"] != true
   end

   def test_authorizing_with_bad_remote_salt_should_suck
      amount = rand(1000).to_s
      remote_salt = '12345'
      bad_remote_salt = '54321'
      card = create_credit_card(:remote_salt => remote_salt)

      assert_no_difference 'Authorization.count' do
        authorize_existing_card(amount, card, bad_remote_salt)
      end
   end


   private

   def create_credit_card options={}
      card_values = { :number         => '4242424242424242', 
                      :year           => Time.now.year + 1, 
                      :month          => Time.now.month, 
                      :name           => "Joe Van Dyk", 
                      :street_address => "123 Main",
                      :city           => "Seattle",
                      :state          => "WA",
                      :zip            => "98115", 
                      :country        => "USA",
                      :remote_salt     => 'blurb' }
      card_values.merge!(options)
      post credit_cards_url(:credit_card => card_values, :format => 'xml')
      assigns(:credit_card)
   end

   def authorize_existing_card amount, card, remote_salt
      post authorize_url(:authorization => { :amount => amount, :credit_card_id => card.id, :remote_salt => remote_salt })
   end

   def capture amount, authorization
      post capture_url(:amount => amount, :authorization => authorization)
   end

end
