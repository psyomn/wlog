require './make_db'
require 'wlog/db_registry'
require 'wlog/domain/issue'

require 'turntables/turntable'

include Wlog

describe Issue do 

  db_name = './default'

  before(:all) do
    make_testing_db(db_name)
    @db = DbRegistry.new(db_name) 
  end

  after(:all) do
    FileUtils.rm db_name
  end

  it "should insert an issue" do
    issue = Issue.new(@db)
    issue.description = "Some issue"
    issue.mark_started!
    issue.insert
    
    ret = @db.last_row_from('issues')
    expect(ret.size).to eq(1)
  end

  it "should delete an issue" do
    issue = Issue.new(@db)
    issue.description = "Delete issue"
    issue.mark_started!
    issue.insert

    issue.delete
    ret = Issue.find(@db, issue.id) 
    expect(ret).to eq(nil)
  end

  it "should mark itself as new" do
    issue = Issue.new(@db)
    issue.mark_started!
    expect(issue.status).to eq(0)
  end

  it "should mark itself as working" do
    issue = Issue.new(@db)
    issue.mark_working!
    expect(issue.status).to eq(1)
  end

  it "should mark itself as finished" do
    issue = Issue.new(@db)
    issue.mark_finished!
    expect(issue.status).to eq(2)
  end

  it "should return nil on issue that is not found" do
    issue = Issue.find(@db, 123123123)
    expect(issue).to eq(nil)
  end

end 

