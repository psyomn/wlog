require_relative '../make_db'
require 'wlog/db_registry'
require 'wlog/domain/log_entry'
require 'wlog/domain/issue'

include Wlog

describe LogEntry do 

  db_name = './default'

  before(:all) do
    make_testing_db(db_name)
    @db = DbRegistry.new(db_name) 
    @issue = Issue.new(@db)
    @issue.description = "Attach logs to me!"
    @issue.insert
  end

  after(:all) do
    FileUtils.rm db_name
  end

  it "should be inserted" do
    le = LogEntry.new(@db)
    desc = "This is a log description" 
    le.description = desc
    le.issue_id = @issue.id
    le.insert

    other = LogEntry.find(@db, le.id)
    expect(other.description).to eq(desc)
    expect(other.issue_id).to eq(@issue.id)
  end 

  it "should handle something that is not found properly" do
    le = LogEntry.find(@db, 12123123123)
    expect(le).to eq(nil)
  end

  it "should not be inserted more than once" do
    previous = LogEntry.find_all(@db).count
    le = LogEntry.new(@db)
    le.description = "derp" 
    le.issue_id = @issue.id
    4.times{ le.insert } 
    after = LogEntry.find_all(@db).count
    expect(after).to eq(previous + 1)
  end

  it "should be deleted from the issue" do
    le = LogEntry.new(@db)
    le.description = "derp derp derp"
    le.issue_id = @issue.id
    le.insert
    id = le.id
    le.delete
    check = LogEntry.find(@db, id)
    expect(check).to eq(nil)
  end

  it "should update to new information" do
    le = LogEntry.new(@db)
    before = "derp"
    after  = "herp"
    le.description = before
    le.issue_id = @issue.id
    le.insert
    le.description = after
    le.update
    check = LogEntry.find(@db, le.id)

    expect(check.description).to eq(after)
  end

  it "should not be created if no issue id bound" do
    le = LogEntry.new(@db)
    le.description = "DERP"
    expect{le.insert}.to raise_error('Need issue_id')
  end

end 

