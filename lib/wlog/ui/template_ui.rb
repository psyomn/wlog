require 'wlog/domain/sys_config'
require 'wlog/commands/bootstrap_templates'

module Wlog
# To list, and choose which template we want to use when making invoices.
# @author Simon Symeonidis
class TemplateUi

  def initialize
    @strmaker = SysConfig.string_decorator
    # Checks for templates dir each run
    BootstrapTemplates.new.execute
  end

  def run
    cmd = 'default'

    while cmd != 'end'
      cmd = gets.chomp
      case cmd
      when /^(ls|show)/
      when /^set/
      when /^help/ then print_help
      when /^end/ then next
      end
    end
  end

private

  def print_help
    ['ls, show', 'list the current templates you can use', 
     'set <num>', 'set the template you want to use',
     'help', 'print this menu'].each_with_index do |cmd,ix|
       puts "  " if ix % 2 == 1
       puts cmd
     end
  end

  def ls
  end

  def set
  end

end
end

