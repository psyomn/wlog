require 'wlog/db_registry'
require 'wlog/sql_modules'
module Wlog
# An active record that stores keys with values. Keys and values are strings.
# convert as you need them.
# @author Simon Symeonidis
class KeyValue
  include KeyValueSql

  # Insert a key in the storage. If exists, replace the value with new one
  # @return nil
  def self.put!(key, value)
    if self.get(key).nil?
      self.create!(key, value)
    else 
      self.update(key, value)
    end
  nil end

  # Get a certain value by key
  # @return the value given the key. nil if not found
  def self.get(key)
    ret = DbRegistry.instance.execute(Select, key)
    ret = ret.empty? ? nil : ret.first
  end

  # destroy by key
  def self.destroy!(key)
    DbRegistry.instance.execute(DeleteSql, key)
  nil end

private

  # We want to provide a simple interface to the kv store, so the user should
  # not really care about updates
  def self.update(key,value)
    DbRegistry.instance.execute(UpdateSql, value, key)
  end

  # Create a pair... ;)
  def self.create!(key, value)
    DbRegistry.instance.execute(InsertSql, key, value)
  end

  class << self
    private :new, :allocate
  end
end 
end # module Wlog

