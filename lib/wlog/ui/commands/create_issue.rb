require 'readline'
require 'wlog/ui/commands/ui_command'
require 'wlog/domain/issue'

module Wlog
# Creational logic for issues
# @author Simon Symeonidis
class CreateIssue < UiCommand
  def initialize(db)
    @db = db
  end

  # Execute create issue transaction
  def execute
    @ret = Issue.new(@db)
    desc = Readline.readline("Small issue description :") || "None."
    ldesc = Readline.readline("Long issue description :") || "None."
    @ret.description = desc.chomp
    @ret.long_description = ldesc
    @ret.insert
  end
  attr_accessor :ret
end
end
