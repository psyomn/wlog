require_relative '../../make_db'
require 'wlog/db_registry'
require 'wlog/domain/log_entry'
require 'wlog/domain/issue'

require 'turntables/turntable'
require 'wlog/commands/replace_pattern'

include Wlog

describe ReplacePattern do
  db_name = './default'
  before(:all) do
    make_testing_db(db_name)
    @db = DbRegistry.new(db_name)
    @issue = Issue.new(@db)
    @log_entry = LogEntry.new(@db)
    @previous_description = "This is my log_entry"

    @issue.description = "This is my issue"
    @issue.insert
    @log_entry.issue_id = @issue.id
    @log_entry.description = @previous_description
    @log_entry.insert
  end

  after(:all) do
    FileUtils.rm db_name
  end

  # I know, tests should not really look for implementation details, but things
  # in our case *should* really inherit the command interface.
  it "should inherit from commandable" do
    command = ReplacePattern.new(@db, @log_entry.id, "asd", "ASD")
    expect(command.is_a? Commandable).to eq(true)
  end

  it "should replace a string in LogEntry on command execution" do
    addition = " my addition"
    command = ReplacePattern.new(@db, @log_entry.id, 'log_entry', 'wlog_entry')
    command.execute
    new_le = LogEntry.find(@db, @log_entry.id)
    expect(new_le.description).to eq('This is my wlog_entry')
  end
end

