require 'wlog/commands/commandable'

module Wlog

class InnitDb < Commandable
  def execute
    current_dir = "#{File.expand_path File.dirname(__FILE__)}/sql"
    turntable   = Turntables::Turntable.new
    turntable.register(current_dir)
    turntable.make_at!("#{DataDirectory}/#{ARGV[0] || DefaultDb}")
  end
end

end
