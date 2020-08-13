require_relative '../../spec_helper'
require_relative '../../make_db'
require 'wlog/domain/attachment'
require 'wlog/domain/log_entry'
require 'wlog/domain/issue'
require 'wlog/commands/new_entry'

include Wlog

describe NewEntry do
  db_name = 'default'
  db_path = standard_db_path(db_name)

  before(:all) do
    make_testing_db(db_name)
    @issue = Issue.new
    @issue.description = 'my issue'
    @issue.save
  end

  after(:all) do
    FileUtils.rm db_path
  end

  it 'should insert a new entry on execution' do
    command = NewEntry.new('my desc', @issue)
    command.execute
    expect(LogEntry.count).to eq(1)
  end

  it 'should create 5 more inserts on 5 more executions' do
    previous = LogEntry.count
    command = NewEntry.new('my desc', @issue)
    5.times { command.execute }
    expect(LogEntry.count).to eq(5 + previous)
  end
end
