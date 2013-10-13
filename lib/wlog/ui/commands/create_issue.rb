require 'wlog/ui/commands/ui_command'
require 'wlog/domain/issue'

module Wlog
# Creational logic for issues
# @author Simon Symeonidis
class CreateIssue < UiCommand
  def execute
    @ret = Issue.new
    print "Small issue description :"
    desc = $stdin.gets || "None."
    @ret.description = desc.chomp
    @ret.insert
  end

  attr_accessor :ret
end
end
