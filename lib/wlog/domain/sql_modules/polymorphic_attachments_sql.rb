module Wlog
# Sql for polymorphic attachments
# @author Simon Symeonidis
module PolymorphicAttachmentsSql

  # The table name
  TableName = "polymorphic_attachments"

  # Select entries by discriminator name, and id
  SelectSql = "SELECT * FROM #{TableName} WHERE "\
    "discriminator = ? AND discriminator_id = ? "

  # Insert an attachment given the current thing in hand
  InsertSql = "INSERT INTO #{TableName} "\
    "(discriminator, discriminator_id, attachment_id) values "\
    "(? , ? , ?)"

  # Delete an attachment from the attached thing
  DeleteSql = "DELETE FROM #{TableName} WHERE "\
   "discriminator = ? AND discriminator_id = ?"

end
end

