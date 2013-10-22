require 'wlog/commands/commandable'
require 'wlog/domain/log_entry'

module Wlog
# Concatenate a string to an existing log entry
class ConcatDescription < Commandable
  def initialize(db, id, str)
    @id = id; @str = str
    @db = db
  end

  # Find and update the log entry
  def execute
    log_entry = LogEntry.find(@db, @id)
    log_entry.description.concat(str)
    log_entry.update
  end

  attr_reader :id, :str

private

  attr :db

end
end # end Wlog module

