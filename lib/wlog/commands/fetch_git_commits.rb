require 'wlog/commands/commandable'
require 'wlog/tech/git_commit_parser'
module Wlog
# Given two dates, extract the git commits.
# @author Simon Symeonidis
class FetchGitCommits < Commandable

  # Configuration to query the git repo for the required commits. You can
  # specify a date range and an author. You need to provide a path to the
  # git repository.
  # @param from   date start
  # @param to     date end
  # @param repo   location to the git repo
  # @param author only show logs of that author. If none is given, fetch all
  #   authors
  # @example 
  #   from_date = DateTime.now - 15
  #   to_date   = DateTime.now + 5
  #   repo      = '/home/jon/wlog/.git/'
  #   cmd = FetchGitCommits.new(from_date, to_date, repo, 'jon')
  def initialize(from, to, repo, author=nil)
    @from, @to, @repo, @author = from, to, repo, author
  end

  # Run the parser on the repo; yield commits
  def execute
    result = `#{run_git_cmd}`
    @commits = GitCommitParser.parse(result)
  nil end

  attr_accessor :commits

private

  # git --git-dir <thedir> log --since=... --until=... --author=...
  def run_git_cmd
    from_s = @from.strftime("%b %d %Y")
    to_s   = @to.strftime("%b %d %Y")
    base = "git --git-dir #{@repo} log "
    base.concat("--since=\"#{from_s}\" ")
    base.concat("--until=\"#{to_s}\" ")
    base.concat("--author=\"#{@author}\"") if @author
  base end

end
end

