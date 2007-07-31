require File.dirname(__FILE__) + '/../../test_helper'

class ChronopayModuleTest < Test::Unit::TestCase
  include ActiveMerchant::Billing::Integrations
  
  def test_notification_method
    assert_instance_of Nochex::Notification, Nochex.notification('name=cody')
  end
end 
