require "test/test_helper"

class BigIntegrationTest < ActionController::IntegrationTest
   def test_the_happy_path
      remote_salt = '12345'

      card = nil
      assert_difference "CreditCard.count" do
         card = create_credit_card(:remote_salt => remote_salt)
      end
      assert_response 201 # FIXME wut

      amount = rand(1000).to_s
      authorize(amount, card, remote_salt)
      assert_response :success
      assert_equal response.headers["X-AuthorizationSuccess"], true, "   \n\n **** if this fails, read the README. **** \n\n"
      assert response.body =~ /^\d+$/
      transaction_id = response.body

      capture(amount, transaction_id)
      assert_response :success
      assert response.headers["X-CaptureSuccess"] == true
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
      transaction_id = authorize(amount, card, remote_salt)
      capture(amount.to_i + 1, transaction_id)  # trying to capture with an amount too high
      assert response.headers["X-CaptureSuccess"] != true
   end

   def test_authorizing_with_bad_remote_salt_should_suck
      amount = rand(1000).to_s
      remote_salt = '12345'
      bad_remote_salt = '54321'
      card = create_credit_card(:remote_salt => remote_salt)

      authorize(amount, card, bad_remote_salt)
      assert response.headers["X-CaptureSuccess"] != true
      assert_equal response.body, "The credit card number is invalid"
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

   def authorize amount, card, remote_salt
      post authorize_url(:amount => amount, :credit_card_id => card.id, :remote_salt => remote_salt)
   end

   def capture amount, transaction_id
      post capture_url(:amount => amount, :transaction_id => transaction_id)
   end

end
