require_relative '../spec_helper'
require_relative '../make_db'
require 'wlog/domain/log_entry'
require 'wlog/domain/issue'

include Wlog

describe LogEntry do

  db_name = 'default'
  db_path = standard_db_path(db_name)

  before(:all) do
    make_testing_db(db_name)
    @issue = Issue.new
    @issue.description = "Attach logs to me!"
    @issue.save
  end

  after(:all) do
    FileUtils.rm db_path
  end

  it "should be inserted" do
    le = LogEntry.new
    desc = "This is a log description"
    le.description = desc
    @issue.log_entries << le

    other = @issue.log_entries.first
    expect(other.description).to eq(desc)
    expect(other.issue_id).to eq(@issue.id)
  end

  it "should handle something that is not found properly" do
    le = LogEntry.find_by_id(12123123123)
    expect(le).to eq(nil)
  end

  it "should not be inserted more than once" do
    previous = LogEntry.count
    le = LogEntry.new
    le.description = "derp"
    le.issue_id = @issue.id
    4.times{ le.save }
    after = LogEntry.count
    expect(after).to eq(previous + 1)
  end

  it "should be deleted from the issue" do
    le = LogEntry.new
    le.description = "derp derp derp"
    le.issue_id = @issue.id
    le.save
    id = le.id
    LogEntry.delete(id)
    check = LogEntry.find_by_id(id)
    expect(check).to eq(nil)
  end

  it "should update to new information" do
    le = LogEntry.new(@db)
    before = "derp"
    after  = "herp"
    le.description = before
    le.issue_id = @issue.id
    le.save
    le.description = after
    le.save
    check = LogEntry.find(le.id)

    expect(check.description).to eq(after)
  end
end
