case RAILS_ENV
when 'test'
   ActiveMerchant::Billing::Base.mode = :test
   $gateway = ActiveMerchant::Billing::AuthorizedNetGateway.new :login => 'cnpdev4399', :password => '29pG9u8uA5vJMj5R'
when 'development'
   ActiveMerchant::Billing::Base.mode = :test
   $gateway = ActiveMerchant::Billing::AuthorizedNetGateway.new :login => 'cnpdev4399', :password => '29pG9u8uA5vJMj5R'
when 'production'
   $gateway = ActiveMerchant::Billing::AuthorizedNetGateway.new :login => 'cnpdev4399', :password => '29pG9u8uA5vJMj5R'
end
