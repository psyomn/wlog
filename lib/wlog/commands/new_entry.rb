require 'wlog/commands/commandable'
require 'wlog/domain/log_entry'

module Wlog
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
