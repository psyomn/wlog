require 'wlog/commands/commandable'
require 'wlog/commands/fetch_git_commits'
require 'wlog/tech/git_commit_parser'
module Wlog
  # We don't set the repo and author - get it directly from keyvalue
  # Use the other git fetcher if you want something more configurable
  # @author Simon Symeonidis
  class FetchGitCommitsStandard < Commandable
    # @param from   date start
    # @param to     date end
    #   authors
    def initialize(from, to)
      @from = from
      @to = to
      @author = KeyValue.get('author')
      @repo   = KeyValue.get('git')
    end

    # Run the parser on the repo; yield commits
    def execute
      cmd = FetchGitCommits.new(@from, @to, @repo, @author)
      cmd.execute
      @commits = cmd.commits
      nil
  end

    attr_accessor :commits
  end
end
