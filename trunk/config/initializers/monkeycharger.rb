case RAILS_ENV
when 'test'
   ActiveMerchant::Billing::Base.mode = :test
   $gateway = ActiveMerchant::Billing::AuthorizedNetGateway.new :login => 'LOGIN', :password => 'PASSWORD'
when 'development'
   ActiveMerchant::Billing::Base.mode = :test
   $gateway = ActiveMerchant::Billing::AuthorizedNetGateway.new :login => 'LOGIN', :password => 'PASSWORD'
when 'production'
   $gateway = ActiveMerchant::Billing::AuthorizedNetGateway.new :login => 'LOGIN', :password => 'PASSWORD'
end
