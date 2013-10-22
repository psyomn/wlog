require_relative '../../make_db'
require 'wlog/db_registry'
require 'wlog/domain/attachment'
require 'wlog/domain/log_entry'
require 'wlog/domain/issue'
require 'wlog/commands/new_entry'

require 'turntables/turntable'

include Wlog

describe NewEntry do 

  db_name = './default'

  before(:all) do
    make_testing_db(db_name)
    @db = DbRegistry.new(db_name) 
    @issue = Issue.new(@db)
    @issue.description = 'my issue'
    @issue.insert
  end

  after(:all) do
    FileUtils.rm db_name
  end

  it "should insert a new entry on execution" do 
    command = NewEntry.new(@db, "my desc", @issue.id)
    command.execute
    expect(LogEntry.find_all(@db).count).to eq(1)
  end

  it "should create 5 more inserts on 5 more executions" do
    previous = LogEntry.find_all(@db).count
    command = NewEntry.new(@db, "my desc", @issue.id)
    5.times{ command.execute }
    expect(LogEntry.find_all(@db).count).to eq(5 + previous)
  end

end
