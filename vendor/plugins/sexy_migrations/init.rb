require 'sexy_migrations'

ActiveRecord::ConnectionAdapters::TableDefinition.send :include, SexyMigrations::Table
ActiveRecord::ConnectionAdapters::AbstractAdapter.send :include, SexyMigrations::Schema
