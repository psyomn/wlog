module Wlog
  # Inherit this for commands
  # @author Simon Symeonidis
  class Commandable
    def execute
      throw NotImplementedError
    end
  end
end
