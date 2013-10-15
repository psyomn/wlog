require 'wlog/db_registry'
require 'wlog/domain/sql_modules/key_value_sql'
module Wlog
# An active record that stores keys with values. Keys and values are strings.
# convert as you need them.
#
# Note the behaviour on this; it's exactly like a ruby hash, so if you store
# a string 'jon' as a key with value '12', and then you store 'jon' with value
# '42', when looking up 'jon' you will retrieve only the latter (42).
#
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

