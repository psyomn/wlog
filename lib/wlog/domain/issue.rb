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

  has_many :log_entries

  StatusNew       = 0
  StatusStarted   = 1
  StatusFinished  = 2
  StatusArchived  = 3

  # Anything which is not archived (eg: new, started work, finished)
  def self.find_not_archived; where("status NOT IN (?)", StatusArchived) end

  # Log the seconds into the issue
  def log_time(sec)
    self.timelog += sec
    save
  end

  def to_s
    le_count = self.log_entries.count
    @strmaker = SysConfig.string_decorator
    "#{@strmaker.yellow('Issue')} ##{id}#{$/}"\
    "  #{@strmaker.blue('Reported')} : #{created_at.asctime}#{$/}"\
    "  #{@strmaker.blue('Due')}      : #{due_date.asctime}#{$/}"\
    "  #{@strmaker.blue('Entries')}  : #{le_count} #{$/}"\
    "  #{@strmaker.blue('Status')}   : #{Statuses[status]}#{$/}"\
    "  #{@strmaker.blue('Time')}     : #{TimelogHelper.time_to_s(timelog)}#{$/}"\
    "#{$/}"\
	 "#{@strmaker.yellow('Summary')} #{$/}"\
    "  #{description}#{$/ + $/}"\
	 "#{@strmaker.yellow('Description')} #{$/}"\
    "  #{Helpers.break_string(long_description, 80)}#{$/ + $/}"
  end

  # Mark issue as started
  def mark_started!; self.status = 0 end
  
  # Mark the issue as working
  def mark_working!; self.status = 1 end
  
  # Mark the issue as finished
  def mark_finished!; self.status = 2 end

  # Archive the issue
  def archive!; self.status = 3 end

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
    StatusNew      => "new", 
    StatusStarted  => "started work", 
    StatusFinished => "finished", 
    StatusArchived => "archived"}

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

