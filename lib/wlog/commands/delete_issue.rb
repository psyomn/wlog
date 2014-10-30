require 'wlog/commands/commandable'
require 'wlog/domain/issue'

module Wlog
# Command for deleting issues
# @author Simon Symeonidis
class DeleteIssue
  # Init with the issue id
  def initialize(id)
    @issue_id = id
    @deleted = false
  end

  # delete the issue
  def execute
    issue = Issue.find(@issue_id)
    if issue
      issue.destroy
      @deleted = true
    end
  rescue ActiveRecord::RecordNotFound
    @deleted = false
  end

  def deleted?
    @deleted
  end

  attr :deleted
end
end
