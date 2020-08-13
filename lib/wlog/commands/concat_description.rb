require 'wlog/commands/commandable'
require 'wlog/domain/log_entry'

module Wlog
  # Concatenate a string to an existing log entry
  class ConcatDescription < Commandable
    def initialize(id, str)
      @id = id
      @str = str
    end

    # Find and update the log entry
    def execute
      log_entry = LogEntry.find(@id)
      log_entry.description += @str
      log_entry.save
    rescue ActiveRecord::RecordNotFound
      false
    end

    attr_reader :id, :str
  end
end # end Wlog module
