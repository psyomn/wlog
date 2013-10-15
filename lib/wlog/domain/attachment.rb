require 'wlog/db_registry'
require 'wlog/domain/sql_modules/attachment_sql'

module Wlog
# <<Active Record>>
# OO way of handling blobs of data, to be stored in memory or in db.
class Attachment
  include AttachmentSql

  # Find an attachment given an id
  # @param id is the attachment id to find
  def self.find_by_discriminator(name, id)
    DbRegistry.instance.execute(SelectSql, name, id)
  end

  # Delete an attachment
  # @param id the attachment with the id to delete
  def self.delete(id)
    DbRegistry.instance.execute(DeleteSql, id)
  end

  # insert an attachment
  def insert
    DbRegistry.instance.execute(InsertSql, @filename, @given_name, @data)
  end

  # [String] Container for the actual binary data of whatever you're
  # attaching.
  attr_accessor :data
  # [String] The original filename of the file
  attr_accessor :filename
  # [String] optional given name for the attachment
  attr_accessor :given_name
end
end # module Wlog

