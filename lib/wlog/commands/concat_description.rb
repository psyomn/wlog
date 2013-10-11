require 'wlog/commands/commandable'
require 'wlog/log_entry'

module Wlog
# Concatenate a string to an existing log entry
class ConcatDescription < Commandable
  def initialize(id, str)
    @id = id; @str = str
  end

  # Find and update the log entry
  def execute
    log_entry = LogEntry.find(@id)
    log_entry.description.concat(str)
    log_entry.update
  end

  attr_reader :id, :str
end
end # end Wlog module

