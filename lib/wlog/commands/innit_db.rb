require 'wlog/commands/commandable'
require 'wlog/domain/static_configurations'

require 'wlog/migrations/make_standard_tables'
require 'wlog/migrations/fix_attachments_polymorphic_table'

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

  # TODO making this public is hacky, but I'm doing this for now for being able
  # to test. Once tests are ok again, then I'm going to refactor this somewhere
  # else so it's more sane.
  def execute_migrations!
    migrations = [MakeStandardTables, FixAttachmentsPolymorphicTable]
    existing = SchemaMigration.all.collect{ |el| el.version }

    migrations.reject!{ |e| existing.include? e.to_s}

    migrations.each do |migration|
      ActiveRecord::Migration.run(migration)
      SchemaMigration.create(:version => migration.name)
    end
  end


private

  # Checks to see if versioning table is there. Create if not.
  def make_schema_migrations!
    ActiveRecord::Migration.verbose = false
    ActiveRecord::Base.configurations = dbconfig
    ActiveRecord::Base.establish_connection(:development)
    ActiveRecord::Base.default_timezone = :local

    unless SchemaMigration.table_exists?
      ActiveRecord::Migration.run(MakeSchemaMigration)
    end
  end

  # TODO this should probably be moved
  def dbconfig
    dbname = DefaultDb
    {'development' => {
     :adapter => 'sqlite3',
     :pool => 5,
     :database => DataDirectory + dbname,
     :timeout => 5000 }}
  end

end
end

