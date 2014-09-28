require_relative '../make_db'
require 'wlog/domain/attachment'
require 'wlog/domain/log_entry'
require 'wlog/domain/issue'

include Wlog

describe Attachment do 

  db_name = './default'
  
  class FileMock
    attr_accessor :filename, :data, :path
  end

  def create_mock_file
    fm = FileMock.new
    fm.filename = "thefile.txt"
    fm.data = "This is my text data." 
    fm.path = "/home/user/"
  fm end

  before(:all) do
    make_testing_db(db_name)
    @db = DbRegistry.new(db_name) 
    @issue = Issue.new(@db)
    @log_entry = LogEntry.new(@db)

    @issue.description = "This is my issue"
    @issue.insert
    @log_entry.issue_id = @issue.id
    @log_entry.description = "This is my log_entry"
    @log_entry.insert
  end

  after(:all) do
    FileUtils.rm db_name
  end

  # Note: this example uses issue, but this will be valid for whatever other
  # type we want to associate to this class. 
  it "should insert given polymorphic type" do
    file = create_mock_file
    attach = Attachment.new(@db, Issue.name, @issue.id)
    attach.filename = file.filename
    attach.data = file.data
    attach.insert
    check = Attachment.find(@db, Issue.name, @issue.id)
    expect(check).to_not eq(nil)
  end

  it "should return nil if something is not found" do
    expect(Attachment.find(@db, Issue.name, 123123123)).to eq(nil)
  end
end 

