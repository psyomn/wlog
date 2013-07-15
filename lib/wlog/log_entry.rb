require 'wlog/db_registry'
require 'wlog/helpers'
require 'wlog/sql_modules/log_entry_sql'

module Wlog
# Author :: Simon Symeonidis 
#  Active Record Domain object for a log entry
class LogEntry
  include LogEntrySql

  def initialize
    @date = Time.new
  end

  def self.find(id)
    row = DbRegistry.instance.execute(Select,id).first
    le = LogEntry.new
    le.id = row[0]
    le.description = row[1]
    le.date = Time.at(row[2])
    le
  end

  def self.find_all
    all = Array.new
    DbRegistry.instance.execute(SelectAll).each do |row|
      le = LogEntry.new
      le.id = row[0]
      le.description = row[1]
      le.date = Time.at(row[2])
      all.push le
    end
    all
  end

  def self.delete(id)
    DbRegistry.instance.execute(DeleteSql,id)
  end

  # TODO this shouldn't be here
  def self.create_table
    DbRegistry.instance.execute(CreateSql)
  end

  # update the entry
  def update
    DbRegistry.instance.execute(UpdateSql,@description,@id)
  end

  # Search by string to find a matching description with 'LIKE'.
  def self.search_descriptions(term)
    all = Array.new
    DbRegistry.instance.execute(SelectDescriptionLike,"%#{term}%").each do |row|
      le = LogEntry.new
      le.id = row[0]
      le.description = row[1]
      le.date = Time.at(row[2])
      all.push le
    end
    all
  end

  def insert
    DbRegistry.instance.execute(InsertSql,@description,@date.to_i)
  end

  # Delete the loaded log entry currently in memory, by passing its id
  def delete
    self.delete(self.id)
  end

  # Print things nicely formmated no more than 80 cars (well, unless you stick
  # the time in the end which is not counted for).
  def to_s
    str    = "[#{id}] "
    tmp    = @description + " [#{@date.strftime("%H:%M:%S")}]"
    desc   = Wlog::Helpers.break_string(tmp,80)
    indent = " " * (id.to_s.split('').count + 5)
    desc.gsub!(/#{$/}/, "#{$/}#{indent}")
    str.concat(desc)
    str
  end

  # The identity field for the log entry DO
  attr_accessor :id

  # Text description for the log entry 
  attr_accessor :description

  # Date the entry was created
  attr_accessor :date
 
end
end # module Wlog

