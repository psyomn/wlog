require 'wlog/db_registry'
require 'wlog/domain/sql_modules/issue_sql'
require 'wlog/domain/log_entry'

module Wlog
# This aggregates log entries. The total time spent on this issue is
# calculated from checking out said log entries.
# @author Simon Symeonidis 
class Issue
  include IssueSql

  def initialize
    @reported_date = Time.now
    @log_entries   = Array.new
    @status        = 0
  end

  def self.find(id)
    issue = Issue.new
    ret = DbRegistry.instance.execute(SelectSql, id).first
    issue.quick_assign! ret
  issue end

  def self.find_all
    arr = Array.new
    DbRegistry.instance.execute(SelectAllSql).each do |row|
      issue = Issue.new
      issue.quick_assign! row
      arr.push issue
    end
  arr end

  def self.delete(id); DbRegistry.instance.execute(DeleteSql, id) end

  def insert
    DbRegistry.instance
      .execute(InsertSql, @description, 
        @reported_date.to_i, @due_date.to_i, @status)
  end

  def delete; DbRegistry.instance.execute(DeleteSql, @id) end

  def update
    DbRegistry.instance
      .execute(UpdateSql, @description, @reported_date.to_i, 
               @due_date.to_i, @status, @id)
  end

  # Add a log entry object to the issue
  def add_log_entry(le)
    @log_entries.push le
  end

  def quick_assign!(row)
    @id, @description, @reported_date, @due_date , @status =\
      row[0], row[1], Time.at(row[2]), Time.at(row[3]), row[4]
  nil end

  def to_s
    "+ Issue ##{@id}#{$/}"\
    "  - Reported : #{@reported_date}#{$/}"\
    "  - Due      : #{@due_date}#{$/}"\
    "  - Entries  : #{@log_entries.count}#{$/}"\
    "  - Status   : "\
    "#{$/}"\
    "  - #{@description}"
  end

  def mark_started!; @status = 0 end
  def mark_working!; @status = 1 end
  def mark_finished!; @status = 2 end
  def status_s; Statuses[@status] end

  # [String] Description of the issue at hand
  attr_accessor :description

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

private

  Statuses = {0 => "new", 1 => "started work", 2 => "finished"}

end # class  Issue
end # module Wlog

