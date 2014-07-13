module Wlog
# The invoice domain object - use this to manipulate invoice recordings, or 
# this along with some renderer and templates in order to create said invoices.
# @author Simon Symeonidis
class Invoice
  def initialize(date_from, date_to)
  end


  attr_accessor :date_from

  attr_accessor :date_to

  # Ultimately this is the location where the invoice template is (in the
  # $HOME/.config/wlog/templates directory).
  attr_accessor :template_location
end
end
