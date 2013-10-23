require 'wlog/ui/commands/ui_command'
require 'wlog/domain/issue'

module Wlog
# Creational logic for issues
# @author Simon Symeonidis
class CreateIssue < UiCommand
  def initialize(db)
    @db = db
  end

  def execute
    @ret = Issue.new(@db)
    print "Small issue description :"
    desc = $stdin.gets || "None."
    @ret.description = desc.chomp
    @ret.insert
  end
  attr_accessor :ret
end
end
