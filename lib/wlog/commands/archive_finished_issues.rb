require 'wlog/commands/commandable'
require 'wlog/commands/archive_issues'
require 'wlog/domain/issue'

module Wlog
  # MacroCommand that archives finished issues
  # @author Simon Symeonidis
  class ArchiveFinishedIssues < Commandable
    def initialize
      @issues = Issue.where(status: 2)
      @arch_command = ArchiveIssues.new(@issues)
    end

    def execute
      @arch_command.execute
    end
  end
end
