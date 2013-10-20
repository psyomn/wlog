require 'sqlite3'
require 'fileutils'

require 'wlog/domain/static_configurations.rb'

module Wlog
# The db registry, using sqlite3
# @author Simon Symeonidis
class DbRegistry
  include StaticConfigurations

  def initialize(dbname)
    @handle = SQLite3::Database.new(dbname || "#{DataDirectory}#{ARGV[0] || DefaultDb}")
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

