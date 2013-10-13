require 'wlog/commands/commandable'
require 'wlog/domain/log_entry'

module Wlog
class NewEntry < Commandable

  def initialize(desc,issue_id); @desc, @iid = desc, issue_id end

  def execute
    log_entry = LogEntry.new
    log_entry.description = @desc
    log_entry.issue_id = @iid
    log_entry.insert
  end
end
end
