require_relative '../make_db'
require 'wlog/domain/key_value'

include Wlog

describe KeyValue do 
 
  db_name = "default"
  db_path = standard_db_path(db_name)

  before(:all) do
    make_testing_db(db_name)
    @kv = KeyValue
  end

  after(:all) do
    FileUtils.rm standard_db_path(db_name)
  end

  it "Should insert a value" do
    @kv.put!('last_check', '2012')
    expect(@kv.get('last_check')).to eq('2012')
  end

  it "Should insert a value only once" do
    @kv.put!('new_check', '2012')
    @kv.put!('new_check', '2013')
    ret = KeyValue.where(:key => 'new_check')
    expect(ret.size).to eq(1)
  end

  it "Should update a previously inserted value" do
    @kv.put!('my_value', '123')
    @kv.put!('my_value', '321')
    expect(@kv.get('my_value')).to eq('321')
  end

end 

