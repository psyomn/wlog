require 'readline'
require 'wlog/domain/invoice'
require 'wlog/domain/sys_config'

module Wlog
# An interface for the invoices
# @author Simon Symeonidis
class InvoiceUi

  def initialize
    @strmaker = SysConfig.string_decorator
  end

  def run
    cmd = "default"

    while cmd != 'end'
      cmd = Readline.readline("[#{@strmaker.red('invoice')}] ")
      case cmd
      when /^new/ then make_invoice
      when /^(ls|show)/ then ls
      when /^end/ then next
      else 
        puts "type 'help' for a list of options"
      end
    end
  end

private

  def ls
    Invoice.all.each do |invoice|
      print "  [#{invoice.id}] " 
      print @strmaker.yellow(invoice.from.strftime("%d-%m-%Y"))
      print @strmaker.blue(" -> ")
      print @strmaker.yellow(invoice.to.strftime("%d-%m-%Y"))
      puts " #{invoice.description.split.first}"
    end
  end

  def print_help
    ['new', 'make a new invoice'].each_with_index do |cmd,ix|
      print '  ' if ix % 2 == 1 
      puts cmd
    end
  end

  def make_invoice
    from_s = Readline.readline("From (dd-mm-yyyy)")
    to_s   = Readline.readline("To   (dd-mm-yyyy)")

    from_d = Date.parse(from_s)
    to_d = Date.parse(to_s)
    description = longtext()

    Invoice.create(:from => from_d, :to => to_d, :description => description)
  end

  def longtext
    times = 3
    str = ""
    count = 0

    while times != 0 do
      cur = Readline.readline()
      str.concat(cur)
      str.concat($/)
      if ["", nil].include? cur
        str.concat($/)
        count += 1
        if count == 2
          times -= 1
          count = 0
        end
      end
    end
  str end

end
end

