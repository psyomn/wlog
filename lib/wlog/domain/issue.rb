require 'wlog/db_registry'
require 'wlog/domain/sql_modules/issue_sql'
require 'wlog/domain/log_entry'
require 'wlog/domain/timelog_helper'

module Wlog
# This aggregates log entries. The total time spent on this issue is
# calculated from checking out said log entries.
# @author Simon Symeonidis 
class Issue
  include IssueSql

  def initialize(db_handle)
    @reported_date = Time.now
    @log_entries   = Array.new
    @status = @seconds = 0
    @db = db_handle
  end

  def self.find(db, id)
    issue = Issue.new(db)
    ret = db.execute(SelectSql, id).first
    if ret.nil? || ret.empty?
      issue = nil
    else 
      issue.quick_assign! ret
    end
  issue end

  def self.find_all(db)
    self.generic_find_all(db, SelectAllSql)
  end

  def self.find_all_finished(db)
    self.generic_find_all(db, SelectFinishedSql)
  end

  def self.find_in_time_range(db, from, to)
    arr = Array.new
    db.execute(SelectTimeRange, from, to).each do |row|
      tmp = Issue.new(@db)
      tmp.quick_assign!(row)
      arr.push tmp
    end
  arr end

  def self.delete_by_id(db, id); db.execute(DeleteSql, id) end

  # inserts the entry into the database if it has not been stored before.
  def insert
    unless @id
      @db.execute(InsertSql, @description, 
        @reported_date.to_i, @due_date.to_i, @status, @long_description)
      @id = @db.last_row_from(TableName).first[0]
    end
  end

  def delete; @db.execute(DeleteSql, @id) end

  def update
    @db.execute(UpdateSql, @description, @reported_date.to_i, 
                @due_date.to_i, @status, @seconds, @id)
  end

  # Add a log entry object to the issue
  # TODO this does nothing / used for nothing yet
  def add_log_entry(le)
    @log_entries.push le
  end

  def quick_assign!(row)
    @id, @description, @reported_date, @due_date, @status, @seconds,
    @long_description =\
      row[0], row[1], Time.at(row[2]), Time.at(row[3]), row[4], 
      row[5] || 0, row[6]
  nil end

  # Log the seconds into the issue
  def log_time(seconds)
    @seconds += seconds
    update
  end

  def to_s
    "+ Issue ##{@id}#{$/}"\
    "  - Reported : #{@reported_date}#{$/}"\
    "  - Due      : #{@due_date}#{$/}"\
    "  - Entries  : #{@log_entries.count}#{$/}"\
    "  - Status   : #{Statuses[@status]}#{$/}"\
    "  - Time     : #{TimelogHelper.time_to_s(@seconds)}#{$/}"\
    "#{$/}"\
    "  - #{@description}#{$/}"\
    "  - #{@long_description}#{$/}"
  end

  # Mark issue as started
  def mark_started!; @status = 0 end
  
  # Mark the issue as working
  def mark_working!; @status = 1 end
  
  # Mark the issue as finished
  def mark_finished!; @status = 2 end

  # Archive the issue
  def archive!; @status = 3 end

  # Get the status as a string
  def status_s; Statuses[@status] end

  # [String] Description of the issue at hand
  attr_accessor :description

  # A longer description that can provide more details as opposed to a simple
  # title as suggested by @description.
  attr_accessor :long_description

  # [Time] The due date of the issue
  attr_accessor :due_date
  
  # [Time] The reported date of the issue
  attr_accessor :reported_date
  
  # [Array<LogEntry>] an array containing the log entries that are specific
  # to this issue
  attr_accessor :log_entries

  # [Fixnum] is the identifier of this object
  attr_accessor :id

  # [Fixnum] Status of the current issue (0 is for not started, 1 working on, 
  # 2 for finished)
  attr_accessor :status

  # The seconds that you have wasted your life on in order to get something
  # done
  attr_accessor :seconds

  # The database handle for this AR
  attr_accessor :db

private

  Statuses = {
    0 => "new", 1 => "started work", 
    2 => "finished", 3 => "archived"}

private_class_method

  def self.generic_find_all(db, sql)
    arr = Array.new
    db.execute(sql).each do |row|
      issue = Issue.new(db)
      issue.quick_assign! row
      arr.push issue
    end
  arr end

end # class  Issue
end # module Wlog

