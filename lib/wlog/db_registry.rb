require 'singleton'
require 'sqlite3'
require 'fileutils'

require 'wlog/static_configurations.rb'
require 'wlog/helpers.rb'

module Wlog
# @author Simon Symeonidis
#  The db registry, using sqlite3
class DbRegistry
  include Singleton
  include StaticConfigurations

  def initialize
    @handle = SQLite3::Database.new("#{DataDirectory}#{ARGV[0] || DefaultDb}")
  end

  def execute(*sql)
    @handle.execute(*sql)
  end

  # the database handle
  attr_accessor :handle

private
end
end # module Wlog

