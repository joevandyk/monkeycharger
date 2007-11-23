##
# inspired by hobo -- http://hobocentral.net
module SexyMigrations
  module Table
    attr_reader :fk_references

    def foreign_key(*args)
      options = args.last.is_a?(Hash) ? args.pop : {}
      args.each do |col| 
        column(id = "#{col}_id", :integer, options)
        if options[:ref]
          reference = options[:ref] == true ? col.to_s.tableize : options[:ref].to_s 
          (@fk_references ||= []) << [id, reference]
        end
      end 
    end
    alias :fkey :foreign_key
    alias :fkeys :foreign_key
    alias :foreign_keys :foreign_key

    def timestamps(*extras)
      (Array(extras) + %w(created_at updated_at)).each do |stamp|
        datetime stamp
      end
    end
    alias :timestamps! :timestamps
    alias :auto_dates  :timestamps
    alias :auto_dates! :timestamps

    def polymorphic(name)
      integer "#{name}_id"
      string  "#{name}_type"
    end
    alias :polymorphic! :polymorphic

    def inheritable
      string :type
    end
    alias :inheritable! :inheritable

    def locking
      integer :lock_version, :default => 0
    end
    alias :locking! :locking
    alias :locks :locking
    alias :locks! :locking

    def method_missing(name, *args)
      return super unless type = simplified_type(name)
      options = args.last.is_a?(Hash) ? args.pop : {}
      args.each { |col| column(col, type, options) }
    end

  private
    def simplified_type(type)
      ActiveRecord::ConnectionAdapters::Column.new(:type_check, 0, type.to_s).type
    end
  end

  module Schema
    def create_table(name, options = {}, &block)
      table_definition = ActiveRecord::ConnectionAdapters::TableDefinition.new(self)
      table_definition.primary_key(options[:primary_key] || "id") unless options[:id] == false

      table_definition.instance_eval &block

      if options[:force]
        drop_table(name, options) rescue nil
      end

      create_sql = "CREATE#{' TEMPORARY' if options[:temporary]} TABLE "
      create_sql << "#{name} ("
      create_sql << table_definition.to_sql

      # if any fk contraints, add them
      if table_definition.fk_references
        table_definition.fk_references.each do |fk|
          create_sql << ",\nCONSTRAINT #{name}_#{fk[0]}_fk FOREIGN KEY (#{fk[0]})
                         REFERENCES #{fk[1]} (id)"
        end
      end
      
      create_sql << ") #{options[:options]}"
      
      execute create_sql
    end
  end
end
