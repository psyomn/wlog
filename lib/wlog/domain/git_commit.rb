module Wlog
# A git commit message
# @author Simon Symeonidis
class GitCommit
  def initialize
    @commit = @author = @shortlog = @message = ""
  end

  attr_accessor :commit, :author, :shortlog, :message
end
end
