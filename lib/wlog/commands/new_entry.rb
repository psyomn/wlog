require 'wlog/commands/commandable'
require 'wlog/domain/log_entry'

module Wlog
class NewEntry < Commandable

  def initialize(desc); @desc = desc end

  def execute
    log_entry = LogEntry.new
    log_entry.description = @desc
    log_entry.insert
  end
end
end
