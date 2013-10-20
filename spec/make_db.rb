# make the testing database in the relative path
def make_testing_db(dbname)
  current_dir = "#{File.expand_path File.dirname(__FILE__)}/../lib/wlog/sql"
  turntable   = Turntables::Turntable.new
  turntable.register(current_dir)
  turntable.make_at!(dbname)
end

