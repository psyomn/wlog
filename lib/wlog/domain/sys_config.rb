require 'wlog/domain/key_value'

module Wlog
# System preferences helper, that stores last accessed stuff and other fluff.
# @author Simon Symeonidis
class SysConfig
  # load the last focused issue
  def self.last_focus
    KeyValue.get('last_focus')
  end

  # store the last focused issue
  def self.last_focus=(issue)
    KeyValue.put!('last_focus', "#{issue}")
  end

private
  class << self
    private :new, :allocate
  end
end
end # module Wlog

