require 'wlog/db_registry'
require 'wlog/commands/commandable'
require 'wlog/domain/static_configurations'

require 'active_record'
require 'sqlite3'

module Wlog

# Only used here
class MakeSchemaMigration < ActiveRecord::Migration
  def change
    create_table :schema_migrations do |t|
      t.text :version
    end
  end
end

# Only used here
class SchemaMigration < ActiveRecord::Base
end

# Command to create the initial database
# @author Simon Symeonidis
class InnitDb < Commandable
  include StaticConfigurations
  def execute
    current_dir = "#{File.expand_path File.dirname(__FILE__)}/../sql"
    make_schema_migrations!
    execute_migrations!
  end

private

  # Checks to see if versioning table is there. Create if not.
  def make_schema_migrations! 
    ActiveRecord::Base.configurations = dbconfig
    ActiveRecord::Base.establish_connection('development')

    unless SchemaMigration.table_exists?
      ActiveRecord::Migration.verbose = false 
      ActiveRecord::Migration.run(MakeSchemaMigration)
    end
  end

  def execute_migrations!
  end

  # TODO this should probably be moved
  def dbconfig
    dbname = ARGV[0] || DefaultDb
    {'development' => {
     :adapter => 'sqlite3',
     :pool => 5,
     :database => DataDirectory + dbname,
     :timeout => 5000 }}
  end

end
end

