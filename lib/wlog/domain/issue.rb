require 'active_record' 

require 'wlog/domain/log_entry'
require 'wlog/domain/timelog_helper'
require 'wlog/domain/sys_config'
require 'wlog/domain/helpers'

module Wlog
# This aggregates log entries. The total time spent on this issue is
# calculated from checking out said log entries.
# @author Simon Symeonidis 
class Issue < ActiveRecord::Base

  # # Calculate the total time that someone has wasted on all the
  # # issues in the current database
  # def self.total_time
  #   # issues = Issue.find_all
  # end

  # def self.find_in_time_range(db, from, to)
  #   arr = Array.new
  #   db.execute(SelectTimeRange, from, to).each do |row|
  #     tmp = Issue.new(@db)
  #     tmp.quick_assign!(row)
  #     arr.push tmp
  #   end
  # arr end

  # def self.delete_by_id(db, id); db.execute(DeleteSql, id) end

  # Log the seconds into the issue
  def log_time(sec)
    seconds += sec
    save
  end

  def to_s
    @strmaker = SysConfig.string_decorator
    "#{@strmaker.yellow('Issue')} ##{id}#{$/}"\
    "  #{@strmaker.blue('Reported')} : #{created_at.asctime}#{$/}"\
    "  #{@strmaker.blue('Due')}      : #{due_date.asctime}#{$/}"\
    "  #{@strmaker.blue('Entries')}  : TODO #{$/}"\
    "  #{@strmaker.blue('Status')}   : #{Statuses[@status]}#{$/}"\
    "  #{@strmaker.blue('Time')}     : #{TimelogHelper.time_to_s(timelog)}#{$/}"\
    "#{$/}"\
	 "#{@strmaker.yellow('Summary')} #{$/}"\
    "  #{description}#{$/ + $/}"\
	 "#{@strmaker.yellow('Description')} #{$/}"\
    "  #{Helpers.break_string(long_description, 80)}#{$/ + $/}"
  end

  # Mark issue as started
  def mark_started!; status = 0 end
  
  # Mark the issue as working
  def mark_working!; status = 1 end
  
  # Mark the issue as finished
  def mark_finished!; status = 2 end

  # Archive the issue
  def archive!; status = 3 end

  # Get the status as a string
  def status_s; Statuses[status] end

  # # [String] Description of the issue at hand
  # attr_accessor :description

  # # A longer description that can provide more details as opposed to a simple
  # # title as suggested by @description.
  # attr_accessor :long_description

  # # [Time] The due date of the issue
  # attr_accessor :due_date
  # 
  # # [Time] The reported date of the issue
  # attr_accessor :reported_date
  # 
  # # [Array<LogEntry>] an array containing the log entries that are specific
  # # to this issue
  # attr_accessor :log_entries

  # # [Fixnum] is the identifier of this object
  # attr_accessor :id

  # # [Fixnum] Status of the current issue (0 is for not started, 1 working on, 
  # # 2 for finished)
  # attr_accessor :status

  # # The seconds that you have wasted your life on in order to get something
  # # done
  # attr_accessor :seconds

  # # The database handle for this AR
  # attr_accessor :db

private

  Statuses = {
    0 => "new", 1 => "started work", 
    2 => "finished", 3 => "archived"}

private_class_method

  # def self.generic_find_all(db, sql)
  #   arr = Array.new
  #   db.execute(sql).each do |row|
  #     issue = Issue.new(db)
  #     issue.quick_assign! row
  #     arr.push issue
  #   end
  # arr end

end # class  Issue
end # module Wlog

