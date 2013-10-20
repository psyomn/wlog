require 'wlog/db_registry'
require 'wlog/domain/helpers'
require 'wlog/domain/attachment'
require 'wlog/domain/sql_modules/log_entry_sql'

module Wlog
# Author :: Simon Symeonidis 
#  Active Record Domain object for a log entry
class LogEntry
  include LogEntrySql

  def initialize(db_handle)
    @date = Time.new
    @db = db_handle
  end

  def self.find(id)
    row = @db.execute(Select,id).first
    le = LogEntry.new
    le.quick_assign!(row[0], row[1], Time.at(row[2]))
  le end

  def find_all
    generic_find_all(SelectAll)
  end

  def find_all_by_issue_id(id)
    generic_find_all(SelectAllByIssue, id)
  end

  # Delete a log entry with a given id. 
  # @example Simple usage
  #   # Since this is a class method:
  #   LogEntry.delete(12)
  def delete_by_id(id)
    @db.execute(DeleteSql,id)
  end

  # update the entry
  def update
    @db.execute(UpdateSql,@description,@id)
  end

  # Search by string to find a matching description with 'LIKE'.
  def search_descriptions(term)
    all = Array.new
    @db.execute(SelectDescriptionLike,"%#{term}%").each do |row|
      le = LogEntry.new
      le.quick_assign!(row[0], row[1], Time.at(row[2]))
      all.push le
    end
  all end

  def insert
    @db.execute(InsertSql, @description, @date.to_i, @issue_id)
  end

  # Delete the loaded log entry currently in memory, by passing its id
  def delete
    delete_by_id(@id)
  end

  def quick_assign!(id,desc,date,issue_id)
    @id, @description, @date, @issue_id = id, desc, date, issue_id
  end

  # Print things nicely formmated no more than 80 cars (well, unless you stick
  # the time in the end which is not counted for).
  def to_s
    str    = "[#{id}] "
    tmp    = @description + " [#{@date.strftime("%H:%M:%S")}]"
    desc   = Helpers.break_string(tmp,80)
    indent = " " * (id.to_s.split('').count + 5)
    desc.gsub!(/#{$/}/, "#{$/}#{indent}")
    str.concat(desc)
  str end

  # The identity field for the log entry DO
  attr_accessor :id

  # Text description for the log entry 
  attr_accessor :description

  # Date the entry was created
  attr_accessor :date

  # The issue id (parent of this log entry)
  attr_accessor :issue_id
 
  # The db handle 
  attr_accessor :db

private
  def generic_find_all(sql, *params)
    all = Array.new
    @db.execute(sql, *params).each do |row|
      le = LogEntry.new
      le.quick_assign!(row[0], row[1], Time.at(row[2]), row[3])
      all.push le
    end
  all end
end
end # module Wlog

