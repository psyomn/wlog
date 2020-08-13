require 'wlog/commands/commandable'
require 'wlog/domain/issue'

module Wlog
  # Command. Given a list of issues, mark them as archived.
  # @author Simon Symeonidis
  class ArchiveIssues < Commandable
    def initialize(issues)
      @issues = issues
    end

    # Update the issues to be marked as archived
    def execute
      @issues.each do |issue|
        issue.archive!
        issue.save
      end
    end
  end
end
