require 'active_record'
require 'zlib'
require 'wlog/domain/sys_config'

module Wlog
# Following the Active Record pattern
# OO way of handling blobs of data, to be stored in memory or in db.
class Attachment < ActiveRecord::Base
  belongs_to :attachable, polymorphic: true

  def to_s
    @strmaker = SysConfig.string_decorator
    str = ''
    str.concat("  [").concat(@strmaker.green(self.id)).concat("] ")
    str.concat(@strmaker.red(self.filename)).concat($/)
  str end

end
end # module Wlog

