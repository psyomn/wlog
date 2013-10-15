require 'wlog/db_registry'
require 'wlog/domain/sql_modules/attachment_sql'
require 'wlog/domain/sql_modules/polymorphic_attachments_sql'

module Wlog
# <<Active Record>>
# OO way of handling blobs of data, to be stored in memory or in db.
class Attachment
  include AttachmentSql
  include PolymorphicAttachmentsSql

  # Create object with compulsory name and id 
  # @param name is the class name of the calling object
  # @param id is the given id from the calling object
  def initialize(name, id)
    @caller_name = name
    @caller_id   = id
  end

  # Find an attachment given an id
  # @param id is the attachment id to find
  def find_by_discriminator(name, id)
    DbRegistry.instance.execute(SelectSql, name, id)
  end

  # Delete an attachment
  # @param id the attachment with the id to delete
  def delete_by_discriminator(name, id)
    DbRegistry.instance.execute(DeleteSql, id)
  end

  # insert an attachment. This also creates the relation in the polymorphic
  # table.
  def insert
    DbRegistry.instance.execute(InsertSql, @filename, @given_name, @data)
  end

  # Assign a row of data to self
  def quick_assign!(row)
    @id, @filename, @given_name, @data = row[0], row[1], row[2], row[3]
  nil end

  # Identifier of the object
  attr_accessor :id
  # Container for the actual binary data of whatever you're
  # attaching.
  attr_accessor :data
  # The original filename of the file
  attr_accessor :filename
  # optional given name for the attachment
  attr_accessor :given_name
  # The class name of the calling object
  attr_accessor :caller_name
  # The caller id of the calling object
  attr_accessor :caller_id
end
end # module Wlog

