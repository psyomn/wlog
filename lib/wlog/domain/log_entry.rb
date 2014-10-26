require 'active_record'

require 'wlog/domain/helpers'
require 'wlog/domain/attachment'

module Wlog
# Author :: Simon Symeonidis 
#  Active Record Domain object for a log entry
class LogEntry < ActiveRecord::Base

  belongs_to :issue

  # Print things nicely formmated no more than 80 cars (well, unless you stick
  # the time in the end which is not counted for).
  def to_s
    str    = "[#{id}] "
    tmp    = "#{description} [#{created_at.strftime("%H:%M:%S")}]"
    desc   = Helpers.break_string(tmp,80)
    indent = " " * (id.to_s.split('').count + 5)
    desc.gsub!(/#{$/}/, "#{$/}#{indent}")
    str.concat(desc)
  str end

private
end
end # module Wlog

