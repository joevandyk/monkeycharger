module Spec
  module Example
    class ExampleGroupFactory
      class << self
        def reset
          @example_group_types = {
            :default => Spec::Example::ExampleGroup,
            :shared => Spec::Example::SharedExampleGroup
          }
        end

        # Registers an example group class +klass+ with the symbol
        # +type+. For example:
        #
        #   Spec::Example::ExampleGroupFactory.register(:farm, Spec::Farm::Example::FarmExampleGroup)
        #
        # This will cause Main#describe from a file living in 
        # <tt>spec/farm</tt> to create example group instances of type
        # Spec::Farm::Example::FarmExampleGroup.
        def register(id, behaviour)
          @example_group_types[id] = behaviour
        end

        def get(id=:default)
          id ||= :default
          if @example_group_types.values.include?(id)
            return id
          else
            return @example_group_types[id]
          end
        end
        
        def get!(id=:default)
          example_group_class = get(id)
          unless example_group_class
            raise "ExampleGroup #{id.inspect} is not registered. Use ::Spec::Example::ExampleGroupFactory.register"
          end
          return example_group_class
        end  

        # Dynamically creates a class 
        def create_example_group(*args, &block)
          opts = Hash === args.last ? args.last : {}
          if opts[:shared]
            return create_shared_example_group(*args, &block)
          else
            superclass = determine_superclass(opts)
            create_example_group_class(superclass, *args, &block)
          end
        end

        protected

        def determine_superclass(opts)
          # new: replaces behaviour_type
          if opts[:type]
            id = opts[:type]

          #backwards compatibility
          elsif opts[:behaviour_type]
            id = opts[:behaviour_type]

          elsif opts[:spec_path] =~ /spec(\\|\/)(#{@example_group_types.keys.join('|')})/
            id = $2.to_sym
          else
            id = :default
          end
          get(id)
        end

        def create_example_group_class(superclass, *args, &block)
          create_uniquely_named_class(superclass) do
            describe(*args)
            register
            module_eval(&block)
          end
        end
        
        def create_uniquely_named_class(superclass, &block)
          example_group_class = Class.new(superclass)
          class_name = "Subclass_#{class_count}"
          superclass.instance_eval do
            const_set(class_name, example_group_class)
          end
          example_group_class.instance_eval(&block)
          example_group_class
        end
        
        def create_shared_example_group(*args, &block)
          shared_example_group = @example_group_types[:shared].new(*args, &block)
          shared_example_group.register
          shared_example_group
        end

        def class_count
          @class_count ||= 0
          @class_count += 1
          @class_count
        end
      end
      self.reset
    end
  end
end
