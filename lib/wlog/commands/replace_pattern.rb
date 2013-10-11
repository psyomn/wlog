require 'wlog/commands/commandable'
require 'wlog/log_entry'

module Wlog
class ReplacePattern < Commandable
  def initialize(id, oldpat, newpat)
    @id, @oldpat, @newpat = id, oldpat, newpat
  end

  def execute
    log_entry = LogEntry.find(id)
    log_entry.description.gsub!(old_pattern, new_pattern)
    log_entry.update
  end

  attr_reader :id, :oldpat, :newpat
end
end

