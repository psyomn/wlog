require 'wlog/commands/commandable'
require 'wlog/domain/log_entry'

module Wlog
# Command that replaces a string pattern found in an entry, with another string
# @author Simon Symeonidis
class ReplacePattern < Commandable
  def initialize(id, oldpat, newpat)
    @id, @oldpat, @newpat = id, oldpat, newpat
  end

  def execute
    log_entry = LogEntry.find(@id)
    log_entry.description = log_entry.description.gsub(/#{@oldpat}/, @newpat)
    log_entry.save
  rescue ActiveRecord::RecordNotFound
    false
  end
end
end
