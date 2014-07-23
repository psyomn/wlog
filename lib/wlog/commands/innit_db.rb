require 'wlog/db_registry'
require 'wlog/commands/commandable'
require 'wlog/domain/static_configurations'
require 'wlog/Rakefile'

module Wlog
# Command to create the initial database
# @author Simon Symeonidis
class InnitDb < Commandable
  include StaticConfigurations
  def execute
    current_dir = "#{File.expand_path File.dirname(__FILE__)}/../sql"
    # turntable.make_at!("#{DataDirectory}#{ARGV[0] || DefaultDb}") 

    # You need to set the env variale to false, else the migrations will pring
    # on the command line
    ENV['VERBOSE'] = 'false'
    Rake::Task["db:migrate"].invoke
  end
end
end

