require 'wlog/commands/commandable'
require 'wlog/domain/log_entry'
require 'wlog/domain/helpers'

module Wlog
  # Create a Csv report with this command
  # @author Simon Symeonidis
  class MakeCsv < Commandable
    # TODO: refactor me. Because I feel like a horrible piece of code.
    def execute
      str = ''
      LogEntry.all.group_by { |el| el.created_at.strftime('%Y-%m-%d') }.each_pair do |key, value|
        str.concat("#{value.first.created_at.strftime('%A')} #{key}\n")
        value.each do |entry|
          str.concat(",\"#{Helpers.break_string(entry.description, 80)}\"#{$/}")
        end
        str.concat($/)
      end
      @ret = str
    end

    attr_accessor :ret
  end
end
