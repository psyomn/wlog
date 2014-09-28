require 'active_record'
require 'readline'
require 'wlog/ui/commands/ui_command'
require 'wlog/domain/issue'

module Wlog
# Creational logic for issues
# @author Simon Symeonidis
class CreateIssue < UiCommand
  # Execute create issue transaction
  def execute
    desc = Readline.readline("Small issue description :") || "None."
    ldesc = Readline.readline("Long issue description :") || "None."
    @ret = Issue.create(:description =>desc.chomp, :long_description => ldesc)
  end
  attr_accessor :ret
end
end
