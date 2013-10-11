require 'singleton'
require 'sqlite3'
require 'fileutils'

require 'wlog/static_configurations.rb'
require 'wlog/helpers.rb'

module Wlog
# @author Simon Symeonidis
#  The db registry, using sqlite3
class DbRegistry
  include Singleton
  include StaticConfigurations

  def initialize
    make_tables = !Helpers.database_exists? 

    @handle = SQLite3::Database.new("#{DataDirectory}#{ARGV[0] || DefaultDb}")
    
    execute(@@log_entry_sql) if make_tables
  end

  def execute(*sql)
    @handle.execute(*sql)
  end

  # the database handle
  attr_accessor :handle

private

  @@log_entry_sql =\
    "CREATE TABLE log_entries (id INTEGER PRIMARY KEY AUTOINCREMENT,"\
    "description TEXT, date DATETIME);"
end
end # module Wlog

