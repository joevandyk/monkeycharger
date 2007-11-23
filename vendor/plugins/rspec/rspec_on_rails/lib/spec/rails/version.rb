module Spec
  module Rails
    module VERSION #:nodoc:
      unless defined?(REV)
        # RANDOM_TOKEN: 0.885013695004692
        REV = "$LastChangedRevision: 2958 $".match(/LastChangedRevision: (\d+)/)[1]
      end
    end
  end
end

# Verifies that the plugin has the same revision as RSpec
if Spec::VERSION::REV != Spec::Rails::VERSION::REV
  raise <<-EOF

############################################################################
Your RSpec on Rails plugin is incompatible with your installed RSpec.

RSpec          : #{Spec::VERSION::FULL_VERSION}
RSpec on Rails : r#{Spec::Rails::VERSION::REV}

Make sure your RSpec on Rails plugin is compatible with your RSpec gem.
See http://rspec.rubyforge.org/documentation/rails/install.html for details.
############################################################################
EOF
end
