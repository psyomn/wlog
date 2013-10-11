require 'wlog/db_registry'
require 'wlog/commands/commandable'
require 'wlog/static_configurations'
require 'turntables/turntable'

module Wlog

# Command to create the initial database
class InnitDb < Commandable
  include StaticConfigurations
  def execute
    DbRegistry.instance
    current_dir = "#{File.expand_path File.dirname(__FILE__)}/../sql"
    p current_dir
    turntable   = Turntables::Turntable.new
    turntable.register(current_dir)
    turntable.make_at!("#{DataDirectory}/#{ARGV[0] || DefaultDb}")
  end
end
end

