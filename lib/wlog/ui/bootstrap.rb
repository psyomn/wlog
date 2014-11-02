require 'wlog/commands/innit_db'
require 'wlog/ui/setup_wizard'
require 'wlog/domain/helpers'

module Wlog
# This takes care of initialization. Place this class between the main entry
# point of the application and, the first transaction you require.
# @author Simon Symeonidis
class Bootstrap
  # make $HOME/.config/wlog standard dirs, and pull up database
  def self.configure!
    Helpers.make_dirs!
    InnitDb.new.execute
    # Initial setup if first time running
    SetupWizard.new.run if Helpers.first_setup?
  end
end
end
