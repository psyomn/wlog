require 'wlog/commands/commandable'
require 'wlog/domain/log_entry'

module Wlog
# Command to create a log entry given an issue id, and a string
# @author Simon Symeonidis
class NewEntry < Commandable

  def initialize(db, desc, issue_id) 
    @desc, @iid = desc, issue_id 
    @db = db
  end

  def execute
    log_entry = LogEntry.new(@db)
    log_entry.description = @desc
    log_entry.issue_id = @iid
    log_entry.insert
  end
end
end
