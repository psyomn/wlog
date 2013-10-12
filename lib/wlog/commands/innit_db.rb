require 'turntables/turntable'

require 'wlog/db_registry'
require 'wlog/commands/commandable'
require 'wlog/domain/static_configurations'
require 'wlog/domain/helpers'

module Wlog
# Command to create the initial database
# @author Simon Symeonidis
class InnitDb < Commandable
  include StaticConfigurations
  def execute
    Helpers.make_dirs!
    current_dir = "#{File.expand_path File.dirname(__FILE__)}/../sql"
    turntable   = Turntables::Turntable.new
    turntable.register(current_dir)
    turntable.make_at!("#{DataDirectory}#{ARGV[0] || DefaultDb}")
  end
end
end

