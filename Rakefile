require "bundler/gem_tasks"
require "./lib/wlog/static_configurations"

namespace :system do
  # Remove data directory. This will remove all your data
  task :rmdata do 
    include Wlog::StaticConfigurations
    puts "Removing data directories from #{DataDirectory}"
    print "You sure you want to remove it? [y/n] "
    FileUtils.rm_rf AppDirectory if $stdin.gets.match(/^y/i)
  end
end

