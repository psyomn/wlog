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
      cmd = Readline.readline("[#{@strmaker.red('invoice')}]")
      case cmd
      when /^new/ then make_invoice
      end
    end
  end

  def make_invoice
  end

end
end

