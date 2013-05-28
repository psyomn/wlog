require 'singleton'
require 'sqlite3'
# Author :: Simon Symeonidis
#  The db registry, using sqlite3
class DbRegistry
  include Singleton

  def initialize
    @db_handle = SQLite3::Database.new("worklog.db")
  end

  def execute(*sql)
    @db_handle.execute(*sql)
  end

  # the database handle
  attr_accessor :db_handle

end
