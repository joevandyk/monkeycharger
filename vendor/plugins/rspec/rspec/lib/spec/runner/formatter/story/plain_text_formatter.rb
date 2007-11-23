module Spec
  module Runner
    module Formatter
      module Story
        class PlainTextFormatter < BaseTextFormatter
          def initialize(options, where)
            super
            @successful_scenario_count = 0
            @pending_scenario_count = 0
            @failed_scenarios = []
            @pending_steps = []
            @previous_type = nil
          end
        
          def run_started(count)
            @count = count
            @output.puts "Running #@count scenarios:\n"
          end

          def story_started(title, narrative)
            @output.puts "Story: #{title}\n\n"
            narrative.each_line do |line|
              @output.print "  "
              @output.print line
            end
          end
        
          def story_ended(title, narrative)
            @output.puts
            @output.puts
          end

          def scenario_started(story_title, scenario_name)
            @scenario_already_failed = false
            @output.print "\n\nScenario: #{scenario_name}"
            @scenario_ok = true
          end
        
          def scenario_succeeded(story_title, scenario_name)
            @successful_scenario_count += 1
          end
        
          def scenario_failed(story_title, scenario_name, err)
            @failed_scenarios << [story_title, scenario_name, err] unless @scenario_already_failed
            @scenario_already_failed = true
          end
        
          def scenario_pending(story_title, scenario_name, msg)
            @pending_steps << [story_title, scenario_name, msg]
            @pending_scenario_count += 1 unless @scenario_already_failed
            @scenario_already_failed = true
          end
        
          def run_ended
            @output.puts "\n\n#@count scenarios: #@successful_scenario_count succeeded, #{@failed_scenarios.size} failed, #@pending_scenario_count pending"
            unless @pending_steps.empty?
              @output.puts "\nPending Steps:"
              @pending_steps.each_with_index do |pending, i|
                title, scenario_name, msg = pending
                @output.puts "#{i+1}) #{title} (#{scenario_name}): #{msg}"
              end
            end
            unless @failed_scenarios.empty?
              @output.print "\nFAILURES:"
              @failed_scenarios.each_with_index do |failure, i|
                title, scenario_name, err = failure
                @output.print %[
    #{i+1}) #{title} (#{scenario_name}) FAILED
    #{err.class}: #{err.message}
    #{err.backtrace.join("\n")}
    ]
              end
            end
          end
        
          def step_succeeded(type, description, *args)
            found_step(type, description, false, *args)
          end
        
          def step_pending(type, description, *args)
            found_step(type, description, false, *args)
            @output.print " (PENDING)"
            @scenario_ok = false
          end
        
          def step_failed(type, description, *args)
            found_step(type, description, true, *args)
            @output.print red(@scenario_ok ? " (FAILED)" : " (SKIPPED)")
            @scenario_ok = false
          end
          
          def collected_steps(steps)
          end

        private

          def found_step(type, description, failed, *args)
            text = if(type == @previous_type)
              "\n  And "
            else
              "\n\n  #{type.to_s.capitalize} "
            end
            i = -1
            text << description.gsub(::Spec::Story::Step::PARAM_PATTERN) { |param| args[i+=1] }
            @output.print(failed ? red(text) : green(text))

            if type == :'given scenario'
              @previous_type = :given
            else
              @previous_type = type
            end
          end
        end
      end
    end
  end
end
