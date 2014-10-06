require_relative '../spec_helper'
require_relative '../make_db'
require 'wlog/domain/sys_config'

include Wlog

describe SysConfig do

  db_name = "default"
  db_path = standard_db_path(db_name)

  before(:all) do
    make_testing_db(db_name)
    @sys = SysConfig.new
  end

  after(:all) do
    FileUtils.rm db_path
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
