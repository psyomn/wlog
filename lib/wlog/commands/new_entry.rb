require 'active_record'
require 'wlog/commands/commandable'
require 'wlog/domain/log_entry'

module Wlog
# Command to create a log entry given an issue id, and a string
# @author Simon Symeonidis
class NewEntry < Commandable

  def initialize(desc, issue) 
    @desc, @issue = desc, issue
  end

  def execute
    log_entry = LogEntry.new(
      :description => @desc, 
      :created_at => Time.now,
      :updated_at => Time.now)

    @issue.log_entries << log_entry
  end
end
end
