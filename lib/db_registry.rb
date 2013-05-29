require 'singleton'
require 'sqlite3'
require 'fileutils'

require 'wlog/static_configurations.rb'

# Author :: Simon Symeonidis
#  The db registry, using sqlite3
class DbRegistry
  include Singleton

  def initialize
    make_dirs
    make_tables = !database_exists? 

    @db_handle = SQLite3::Database.new(
      "#{StaticConfigurations::DATA_DIRECTORY}"\
      "#{ARGV[0] || StaticConfigurations::DEFAULT_DATABASE}")
    
    if make_tables 
      execute(@@log_entry_sql)
    end
  end

  def execute(*sql)
    @db_handle.execute(*sql)
  end

  # the database handle
  attr_accessor :db_handle

private
  # NOTE this concern could be encapsulated in another class
  def make_dirs
    # Does the data dir path not exist?
    unless File.exists? StaticConfigurations::DATA_DIRECTORY
      FileUtils.mkdir_p StaticConfigurations::DATA_DIRECTORY
    end
    
  end

  def database_exists?
    File.exists?\
      "#{StaticConfigurations::DATA_DIRECTORY}#{ARGV[0]\
      || StaticConfigurations::DEFAULT_DATABASE}"
  end

  @@log_entry_sql =\
    "CREATE TABLE log_entries (id INTEGER PRIMARY KEY AUTOINCREMENT,"\
    "description TEXT, date DATETIME);"
end
