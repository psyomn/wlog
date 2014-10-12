require 'active_record'
require 'zlib'
require 'wlog/domain/sys_config'

module Wlog
# Following the Active Record pattern
# OO way of handling blobs of data, to be stored in memory or in db.
class Attachment < ActiveRecord::Base
  before_save :compress_string
  after_initialize :uncompress_string
  belongs_to :attachable, polymorphic: true

  def to_s
    @strmaker = SysConfig.string_decorator
    str = ''
    str.concat("  [").concat(@strmaker.green(self.id)).concat("] ")
    str.concat(@strmaker.red(self.filename)).concat($/)
  str end

private

  def compress_string
    Zlib::Deflate.deflate self.data
  end

  def uncompress_string
    Zlib::Inflate.inflate self.data
  end

end
end # module Wlog

