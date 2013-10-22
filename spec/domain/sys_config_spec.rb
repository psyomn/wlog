require_relative '../make_db'
require 'wlog/db_registry'
require 'wlog/domain/attachment'
require 'wlog/domain/log_entry'
require 'wlog/domain/issue'

require 'turntables/turntable'

describe SysConfig do

  before(:all) do
    make_testing_db(db_name)
    @db = DbRegistry.new(db_name) 
  end

  after(:all) do
    FileUtils.rm db_name
  end

end
