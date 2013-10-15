require 'singleton'
require 'sqlite3'
require 'fileutils'

require 'wlog/domain/static_configurations.rb'

module Wlog
# @author Simon Symeonidis
#  The db registry, using sqlite3
class DbRegistry
  include Singleton
  include StaticConfigurations

  def initialize
    @handle = SQLite3::Database.new("#{DataDirectory}#{ARGV[0] || DefaultDb}")
  end

  # execute a sql with varargs parameters
  # @param *sql, first the sql string, then the parameters if the statement is
  #   to be prepared. 
  # @example Simple Usage
  #   DbRegistry.execute("SELECT * FROM table WHERE id = ?", 1)
  def execute(*sql)
    @handle.execute(*sql)
  end

  # Get the last row, given a table name. The table needs to have an id
  def last_row_from(tablename)
    query = "SELECT * FROM #{tablename} WHERE id =(SELECT MAX(id) FROM"\
      " #{tablename});"
    @handle.execute(query)
  end

  # the database handle
  attr_accessor :handle

private
end
end # module Wlog

