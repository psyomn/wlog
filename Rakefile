require "bundler/gem_tasks"
require "rspec/core/rake_task"
require "./lib/wlog/domain/static_configurations"

RSpec::Core::RakeTask.new(:spec)

# Anything that has to do with the stuff of this gem in .config/wlog
namespace :data do
  desc "Remove all configuration data of wlog"
  task :rm do
    include Wlog::StaticConfigurations
    print "You sure you want to remove #{AppDirectory}? [y/n] :"
    FileUtils.rm_rf AppDirectory if $stdin.gets.match(/^y/i)
  end
end

namespace :db do
  # Remove data directory. This will remove all your data
  desc "Remove All the databases"
  task :rm do
    include Wlog::StaticConfigurations
    puts "Removing data directories from #{DataDirectory}"
    print "You sure you want to remove it? [y/n] "
    FileUtils.rm_rf AppDirectory if $stdin.gets.match(/^y/i)
  end

  desc "Run the sqlite3 console with the default database"
  task :c do
    include Wlog::StaticConfigurations
    sh "sqlite3 #{DataDirectory}#{DefaultDb}"
  end
end

namespace :reek do
  desc "Run reek at lib/"
  task :all do
    sh "reek lib/"
  end

  desc "Grep long parameter list"
  task :lparam do
    sh "reek 2>&1 lib/ | grep -i param"
  end

end

namespace :test do
  task :all => :spec
end
