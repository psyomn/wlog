require 'wlog/commands/commandable'
require 'wlog/domain/issue'

module Wlog
# Command for deleting issues
# @author Simon Symeonidis
class DeleteIssue
  # Init with the db handle, and issue id
  def initialize(db, id)
    @db = db
    @issue_id = id
    @deleted = false
  end

  # delete the issue
  def execute
    issue = Issue.find(@db, @issue_id)
    if issue
      issue.delete
      @deleted = true
    end
  end

  def deleted?
    @deleted
  end

  attr :deleted
end
end

