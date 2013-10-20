require './make_db'
require 'wlog/db_registry'
require 'wlog/domain/key_value'

require 'turntables/turntable'

include Wlog

describe KeyValue do 
 
  DbName = "./default"

  before(:all) do
    make_testing_db
    @kv = KeyValue.new(DbRegistry.new(DbName))
  end

  after(:all) do
    FileUtils.rm DbName
  end

  it "Should insert a value" do
    @kv.put!('last_check', '2012')
    expect(@kv.get('last_check')).to eq('2012')
  end

  it "Should insert a value only once" do
    @kv.put!('new_check', '2012')
    @kv.put!('new_check', '2013')
    db = SQLite3::Database.new DbName
    ret = db.execute('select * from key_values where key = ?', 'new_check')
    expect(ret.size).to eq(1)
  end

  it "Should update a previously inserted value" do
    @kv.put!('my_value', '123')
    @kv.put!('my_value', '321')
    expect(@kv.get('my_value')).to eq('321')
  end

end 

