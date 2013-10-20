module Wlog
# This is the session that contains data about a particular run (for example
# what kind of database to use, etc).
# @author Simon Symeonidis
class Session

  def initialize(dbhandle)
    @db = dbhandle
  end

  attr_accessor :db

end
end
