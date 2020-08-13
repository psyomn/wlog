require 'date'
require 'wlog/domain/invoice'
require 'wlog/domain/issue'
require 'wlog/domain/log_entry'
require 'wlog/tech/git_commit_parser'

$sn = 0

module DomainHelpers
  def sn
    old = $sn
    $sn += 1
    old
  end

  # Make a log entry but don't store it
  def make_log_entry
    le = LogEntry.new(description: "Desc ##{sn}")
    le
  end

  def make_issue
    is = Issue.new(description: "Desc #{sn}",
                   due_date: DateTime.now,
                   status: 0,
                   timelog: 10,
                   long_description: "big desc #{sn}")
    is
  end
end
