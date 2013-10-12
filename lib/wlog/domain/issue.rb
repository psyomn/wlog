require 'wlog/domain/log_entry'

module Wlog
# @author Simon Symeonidis 
# This aggregates log entries. The total time spent on this issue is
# calculated from checking out said log entries.
class Issue

  def initialize
    @reported_date = Time.now
    @log_entries   = Array.new
  end

  # Add a log entry object to the issue
  def add_log_entry(le)
    @log_entries.push le
  end

  def to_s
    "Issue ##{@id}#{$/}"\
    "  - Reported : #{@reported_date}#{$/}"\
    "  - Due      : #{@due_date}#{$/}"\
    "  - Entries  : #{@log_entries.count}"\
    "#{$/}"\
    "  - #{@description}"
  end

  attr_accessor :description
  attr_accessor :due_date
  attr_accessor :reported_date
  
  # [Array<LogEntry>] an array containing the log entries that are specific
  # to this issue
  attr_accessor :log_entries
  attr_accessor :id

end # class  Issue
end # module Wlog

