require "test/test_helper"

class BigIntegrationTest < ActionController::IntegrationTest
   def test_the_stack
      amount = rand(1000).to_s
      card = create_credit_card

      authorize(amount, card)
      assert_response :success
      assert response.headers["X-AuthorizationSuccess"] == true
      assert response.body =~ /\d+/
      transaction_id = response.body

      capture(amount, transaction_id)
      assert_response :success
      assert response.headers["X-CaptureSuccess"] == true
   end

   def test_with_bad_amount_should_fail
      amount = rand(1000).to_s
      card = create_credit_card
      transaction_id = authorize(amount, card)
      capture(amount.to_i + 1, transaction_id)  # trying to capture with an amount too high
      assert response.headers["X-CaptureSuccess"] != true
   end

   private

   def create_credit_card options={}
      card_values = { :number         => '4242424242424242', 
                      :year           => Time.now.year + 1, 
                      :month          => Time.now.month, 
                      :name           => "Joe Van Dyk", 
                      :cvv            => "123",
                      :street_address => "123 Main",
                      :city           => "Seattle",
                      :state          => "WA",
                      :zip            => "98115", 
                      :country        => "USA" }
      card_values.merge(options)
      assert_difference "CreditCard.count" do
         post credit_cards_url(:credit_card => card_values, :format => 'xml')
      end
      assert_response 201 # FIXME wut
      assigns(:credit_card)
   end

   # If this fails, make sure that you have set up your external payment gateways 
   # correctly (in config/initializers/monkeycharger.rb)
   def authorize amount, card
      post authorize_url(:amount => amount, :credit_card_id => card.id)
   end

   def capture amount, transaction_id
      post capture_url(:amount => amount, :transaction_id => transaction_id)
   end

end
