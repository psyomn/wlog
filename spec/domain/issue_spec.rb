require_relative '../make_db'
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

  it "should find all the inserted values" do
    issue1 = Issue.new(@db)
    issue2 = Issue.new(@db) 
    issue3 = Issue.new(@db)

    issue1.description = "find me 1"
    issue2.description = "find me 2" 
    issue3.description = "find me 3"
    
    issue1.insert
    issue2.insert
    issue3.insert

    arr = Issue.find_all(@db)
    descs = arr.collect{|issue| issue.description}
    existing = descs & ["find me 1", "find me 2", "find me 3"]
    expect(existing.size).to eq(3)
  end

  it "should not insert an existing value twice" do
    issue = Issue.new(@db)
    issue.description = "Add me once"
    previous = Issue.find_all(@db).count
    issue.insert
    issue.insert
    issue.insert
    issue.insert
    newcount = Issue.find_all(@db).count
    expect(newcount).to eq(previous + 1)
  end

  it "should update with valid information" do
    issue = Issue.new(@db)
    previous = "Update me"
    after    = "UPDATED"
    issue.description = previous
    issue.insert
    issue.description = after
    issue.update

    uissue = Issue.find(@db, issue.id)
    expect(uissue.description).to eq(after)
  end

  it "should accept attachments" do
  end
end 

