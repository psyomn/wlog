require 'active_record'
module Wlog
# An active record that stores keys with values. Keys and values are strings.
# convert as you need them.
#
# Note the behaviour on this; it's exactly like a ruby hash, so if you store
# a string 'jon' as a key with value '12', and then you store 'jon' with value
# '42', when looking up 'jon' you will retrieve only the latter (42).
#
# @author Simon Symeonidis
class KeyValue < ActiveRecord::Base
  include KeyValueSql

  def initialize(db_handle)
    @db = db_handle
  end

  # Insert a key in the storage. If exists, replace the value with new one
  # @return nil
  def put!(key, value)
    if get(key).nil?
      create!(key, value)
    else 
      update(key, value)
    end
  end

  # Get a certain value by key
  # @return the value given the key. nil if not found
  def get(key)
    ret = @db.execute(Select, key)
    ret = ret.empty? ? nil : ret.first[1]
  end

  # destroy by key
  def destroy!(key)
    @db.execute(DeleteSql, key)
  nil end

  # The db handle
  attr_accessor :db

private

  # We want to provide a simple interface to the kv store, so the user should
  # not really care about updates
  def update(key,value)
    @db.execute(UpdateSql, value, key)
  end

  # Create a pair... ;)
  def create!(key, value)
    @db.execute(InsertSql, key, value)
  end

end 
end # module Wlog

