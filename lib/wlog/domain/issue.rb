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

  has_many :log_entries, dependent: :delete_all
  has_many :attachments, as: :attachable

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

private
  Statuses = {
    StatusNew      => "new", 
    StatusStarted  => "started work", 
    StatusFinished => "finished", 
    StatusArchived => "archived"}

private_class_method

end # class  Issue
end # module Wlog

