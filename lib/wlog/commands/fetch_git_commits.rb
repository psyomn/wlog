require 'wlog/commands/commandable'
require 'wlog/tech/git_commit_parser'
module Wlog
# Given two dates, extract the git commits.
# @author Simon Symeonidis
class FetchGitCommits < Commandable

  # @param from   date start
  # @param to     date end
  # @param repo   location to the git repo
  # @param author only show logs of that author. If none is given, fetch all
  #   authors
  def initialize(from, to, repo, author=nil)
    @from, @to, @repo, @author = from, to, repo, author
  end

  def execute
    result = `#{run_git_cmd}`
    @commits = GitCommitParser.parse(result)
  nil end

  attr_accessor :commits

private

  # git --git-dir <thedir> log --since=... --until=... --author=...
  def run_git_cmd
    base = "git --git-dir #{@repo} log "
    base.concat("--since=\"#{@from}\" ")
    base.concat("--until=\"#{@to}\" ")
    base.concat("--author=\"#{@author}\"") if @author
  base end

end
end

