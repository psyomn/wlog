require_relative '../spec_helper'
require_relative '../make_db'
require 'wlog/domain/issue'

include Wlog

describe Issue do 

  db_name = 'default'

  before(:all) do
    make_testing_db(db_name)
  end

  after(:all) do
    close_testing_db
    FileUtils.rm standard_db_path(db_name)
  end

  it "should insert an issue" do
    issue = Issue.new
    issue.description = "Some issue"
    issue.mark_started!
    issue.save
    
    ret = Issue.all
    expect(ret.size).to eq(1)
  end

  it "should delete an issue" do
    issue = Issue.new
    issue.description = "Delete issue"
    issue.mark_started!
    issue.save
    issue.delete

    ret = Issue.find_by_id(issue.id) 
    expect(ret).to eq(nil)
  end

  it "should mark itself as new" do
    issue = Issue.new
    issue.mark_started!
    expect(issue.status).to eq(0)
  end

  it "should mark itself as working" do
    issue = Issue.new
    issue.mark_working!
    expect(issue.status).to eq(1)
  end

  it "should mark itself as finished" do
    issue = Issue.new
    issue.mark_finished!
    expect(issue.status).to eq(2)
  end

  it "should return nil on issue that is not found" do
    issue = Issue.find_by_id(123123123)
    expect(issue).to eq(nil)
  end

  it "should find all the inserted values" do
    issue1 = Issue.new
    issue2 = Issue.new
    issue3 = Issue.new

    issue1.description = "find me 1"
    issue2.description = "find me 2" 
    issue3.description = "find me 3"
    
    issue1.long_description = "long desc 1"
    issue2.long_description = "long desc 2"
    issue3.long_description = "long desc 3"
    
    issue1.save
    issue2.save
    issue3.save

    arr = Issue.all
    descs  = arr.collect{|issue| issue.description}
    ldescs = arr.collect{|issue| issue.long_description}
    existing = descs & ["find me 1", "find me 2", "find me 3"]
    lexisting = ldescs & ["long desc 1", "long desc 2", "long desc 3"]
    expect(existing.size).to eq(3)
    expect(lexisting.size).to eq(3)
  end

  it "should not insert an existing value twice" do
    issue = Issue.new
    issue.description = "Add me once"
    previous = Issue.all.count
    issue.save
    issue.save
    issue.save
    issue.save
    newcount = Issue.all.count
    expect(newcount).to eq(previous + 1)
  end

  it "should update with valid information" do
    issue = Issue.new
    previous = "Update me"
    after    = "UPDATED"
    issue.description = previous
    issue.save
    issue.description = after
    issue.save

    uissue = Issue.find(issue.id)
    expect(uissue.description).to eq(after)
  end

  it "should find all finished issues" do
    4.times do 
      iss = Issue.new
      iss.description = "hello"
      iss.mark_finished!
      iss.save
    end
    issues = Issue.where(:status => 2)

    issues.each do |iss|
      expect(iss.status).to eq(2)
    end
  end

  it "should accept attachments" do
  end
end 

