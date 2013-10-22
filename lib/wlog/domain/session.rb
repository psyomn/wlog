module Wlog
# This is the session that contains data about a particular run (for example
# what kind of database to use, etc). NOTE: this is a placeholder for now. 
# Eventually this should be the object passed on sessions (for example, the
# active records should get the session object, and extract what they need from
# it - the db reference).
# @author Simon Symeonidis
class Session

  def initialize(dbhandle)
    @db = dbhandle
  end

  attr_accessor :db

end
end
