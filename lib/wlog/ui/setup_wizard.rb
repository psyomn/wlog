require 'readline'
require 'wlog/domain/sys_config'
require 'wlog/commands/taint_setup'

module Wlog
# This is the ui that is displayed whenever we detect that it is the first
# time that the application runs. Use this
# __ONLY__ for system wide configuration
# @author Simon Symeonidis
class SetupWizard
  def initialize
  end

  # Call this to prompt the user for things
  def run
    get_setting
    SysConfig.store_config('ansi', @input)
    TaintSetup.new.execute
  end

private 

  def get_setting
    question = "Do you use a terminal that supports ANSI colors? [yes/no] :"
    until ['yes', 'no'].include? input
      @input = Readline.readline(question)
      @input.chomp!
    end
  end

  attr :input

end
end
