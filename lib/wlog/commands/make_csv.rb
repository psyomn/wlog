require 'wlog/commands/commandable'

module Wlog
# Create a Csv report with this command
# @author Simon Symeonidis
class MakeCsv < Commandable
  def execute
    str = ""
    LogEntry.find_all.group_by{|el| el.date.strftime("%Y-%m-%d")}.each_pair do |key,value|
      str.concat("#{value.first.date.strftime("%A")} #{key}\n")
      value.each do |entry|
        str.concat(",\"#{Helpers.break_string(entry.description,80)}\"#{$/}")
      end
      str.concat($/)
    end
    @ret = str
  end

  attr_accessor :ret
end
end

