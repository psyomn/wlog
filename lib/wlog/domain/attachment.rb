require 'active_record'
module Wlog
# Following the Active Record pattern
# OO way of handling blobs of data, to be stored in memory or in db.
class Attachment < ActiveRecord::Base
  belongs_to :imageable, polymorphic: true

  # Can only initialize with a caller name and id, since relations to
  # attachments are polymorphic.
  # def initialize(dbhandle, caller_name, caller_id)
  #   @caller_name, @caller_id, @db = caller_name, caller_id, dbhandle
  # end

  # Find an attachment given an id
  # @param id is the attachment id to find
  # def self.find_all_by_discriminator(db, name, id)
  #   arr = Array.new
  #   rows = db.execute(
  #     PolymorphicAttachmentsSql::SelectSql, name, id)

  #   rows.each do |row| 
  #     arr.push self.find(db, name, row[2])
  #   end
  # arr end

  # # Delete an attachment
  # # @param id the attachment with the id to delete
  # def delete_by_discriminator(name, id)
  #   @db.execute(DeleteSql, id)
  # end

  # # Find an attachment by an identifier and polymorphic name
  # # @param id is the identifier of the attachment to find
  # # @param name is the name of the polymorphic thing
  # def self.find(db, name, id)
  #   row = db.execute(AttachmentSql::SelectSql, id).first
  #   att = nil
  #   if row && !row.empty?
  #     att = Attachment.new(db, name, id)
  #     att.quick_assign!(row)
  #   end
  # att end

  # # Insert an attachment. This also creates the relation in the polymorphic
  # # table.
  # def insert
  #   unless @id
  #     @db.execute(
  #       AttachmentSql::InsertSql, @filename, @given_name, @data)
  #     ret = @db.last_row_from(AttachmentSql::TableName)
  #     @id = ret.first[0].to_i
  #     @db.execute(
  #       PolymorphicAttachmentsSql::InsertSql, @caller_name, @caller_id, @id)
  #   end
  # end

  # # Assign a row of data to self
  # def quick_assign!(row)
  #   @id, @filename, @given_name, @data = row[0], row[1], row[2], row[3]
  # nil end

end
end # module Wlog

