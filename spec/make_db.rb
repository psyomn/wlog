require 'active_record'
require 'wlog/commands/innit_db'

# make the testing database in the relative path
def make_testing_db(dbname)
  current = standard_db_path(dbname)
  ActiveRecord::Base.configurations = {
    'testing' => {
      :adapter => 'sqlite3',
      :database => current,
      :pool => 5,
      :timeout => 5000
    }
  }
  ActiveRecord::Base.establish_connection(:testing)
  setup_db
end

def close_testing_db
  ActiveRecord::Base.connection.close
end

# make the tables, and perform possible migrations
def setup_db
  ActiveRecord::Migration.verbose = false
  ActiveRecord::Migration.run(MakeSchemaMigration)

  InnitDb.new.execute_migrations!
end

def standard_db_path(dbname)
  "#{File.expand_path File.dirname(__FILE__)}/#{dbname}"
end
