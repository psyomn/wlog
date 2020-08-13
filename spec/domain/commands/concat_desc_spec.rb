require_relative '../../spec_helper'
require_relative '../../make_db'
require 'wlog/domain/attachment'
require 'wlog/domain/log_entry'
require 'wlog/domain/issue'

require 'wlog/commands/concat_description'

include Wlog

describe ConcatDescription do
  db_name = 'default'
  db_path = standard_db_path(db_name)

  before(:all) do
    make_testing_db(db_name)
    @issue = Issue.new
    @log_entry = LogEntry.new
    @previous_description = 'This is my log_entry'

    @issue.description = 'This is my issue'
    @issue.save
    @log_entry.issue_id = @issue.id
    @log_entry.description = @previous_description
    @log_entry.save
  end

  after(:all) do
    FileUtils.rm db_path
  end

  # I know, tests should not really look for implementation details, but things
  # in our case *should* really inherit the command interface.
  it 'should inherit from commandable' do
    command = ConcatDescription.new(@log_entry.id, 'asd')
    expect(command.is_a?(Commandable)).to eq(true)
  end

  it 'should concatenate a string on command execution' do
    addition = ' my addition'
    command = ConcatDescription.new(@log_entry.id, addition)
    command.execute
    new_le = LogEntry.find(@log_entry.id)
    expect(new_le.description).to eq(@previous_description + addition)
  end
end
