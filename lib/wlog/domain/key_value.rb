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

  # Insert a key in the storage. If exists, replace the value with new one
  # @return nil
  def self.put!(key, value)
    if ret = KeyValue.find_by_key(key)
      ret.value = value
    else 
      ret = KeyValue.new(:key => key, :value => value)
    end
    ret.save
  end

  # Get a certain value by key
  # @return the value given the key. nil if not found
  def self.get(key)
    ret = find_by_key(key)
    ret = ret ? ret.value : nil
  end

private
end 
end # module Wlog

