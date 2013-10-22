require 'wlog/domain/key_value'

module Wlog
# System preferences helper, that stores last accessed stuff and other fluff.
# @author Simon Symeonidis
class SysConfig

  def initialize(db)
    @db = db
    @key_value = KeyValue.new(@db)
  end

  # load the last focused issue
  def last_focus
    @key_value.get('last_focus')
  end

  # store the last focused issue
  def last_focus=(issue)
    @key_value.put!('last_focus', "#{issue}")
  end

  attr_accessor :db

private

  attr :key_value

end
end # module Wlog

