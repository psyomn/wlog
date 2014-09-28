require_relative '../make_db'
require 'wlog/db_registry'
require 'wlog/domain/sys_config'

include Wlog

describe SysConfig do

  db_name = "./default"

  before(:all) do
    make_testing_db(db_name)
    @db = DbRegistry.new(db_name) 
    @sys = SysConfig.new(@db)
  end

  after(:all) do
    FileUtils.rm db_name
  end

  it "should store last focus" do
    @sys.last_focus = "something_there"
  end

  it "should load last focus" do
    expect(@sys.last_focus).to eq("something_there")
  end

  it "should store once, and on next store overwrite last focus" do
    @sys.last_focus = "something_now"
    @sys.last_focus = "something_then"
    expect(@sys.last_focus).to eq("something_then")
  end


end
