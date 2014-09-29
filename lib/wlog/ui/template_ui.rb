require 'readline'
require 'wlog/domain/sys_config'
require 'wlog/commands/bootstrap_templates'
require 'wlog/domain/sys_config'
require 'wlog/domain/static_configurations'

module Wlog
# To list, and choose which template we want to use when making invoices.
# @author Simon Symeonidis
class TemplateUi
  include StaticConfigurations

  def initialize
    @strmaker = SysConfig.string_decorator
    # Checks for templates dir each run
    BootstrapTemplates.new.execute
  end

  def run
    cmd = 'default'

    while cmd != 'end'
      cmd = Readline.readline("[#{@strmaker.green('templates')}] ").chomp
      case cmd
      when /^(ls|show)/ then ls
      when /^set/       then set(cmd.split.drop 1)
      when /^help/      then print_help
      when /^end/       then next
      end
    end
  end

private

  def print_help
    ['ls, show', 'list the current templates you can use', 
     'set <num>', 'set the template you want to use',
     'help', 'print this menu'].each_with_index do |cmd,ix|
       print "  " if ix % 2 == 1
       puts cmd
     end
  end

  def ls
    num = SysConfig.get_config('template') || 1
    num = num.to_i
    Dir[TemplateDir + "*"].each_with_index do |file,ix|
      print " #{ix + 1 == num ? @strmaker.blue('*') : ' '}  "
      puts file
    end
  end

  def set(rest)
    num = rest[0]
    unless num
      puts "usage: set <number>"
      return
    end

    SysConfig.store_config('template', num)
  end

end
end

