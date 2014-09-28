require 'active_record'
# make the testing database in the relative path
def make_testing_db(dbname)
  current = "#{File.expand_path File.dirname(__FILE__)}/#{dbname}-test.sqlite3"
  ActiveRecord::Base.configure = {
    'testing' => {
      :adapter => 'sqlite3',
      :database => current,
      :pool => 5,
      :timeout => 5000
    }
  }
  ActiveRecord::Base.establish_connection(:testing)
end

