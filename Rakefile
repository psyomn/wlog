require "bundler/gem_tasks"
require "rspec/core/rake_task"
require "./lib/wlog/static_configurations"

RSpec::Core::RakeTask.new(:spec)

namespace :system do
  # Remove data directory. This will remove all your data
  task :rmdata do 
    include Wlog::StaticConfigurations
    puts "Removing data directories from #{DataDirectory}"
    print "You sure you want to remove it? [y/n] "
    FileUtils.rm_rf AppDirectory if $stdin.gets.match(/^y/i)
  end
end


namespace :test do 
  task :all => :spec
end 
