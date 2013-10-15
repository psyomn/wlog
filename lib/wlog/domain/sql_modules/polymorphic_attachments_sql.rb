module Wlog
# Sql for polymorphic attachments
# @author Simon Symeonidis
module PolymorphicAttachmentsSql

  # Insert an attachment given the current thing in hand
  InsertSql = "INSERT INTO polymorphic_attachments "\
    "(discriminator, discriminator_ir, attachment_id) values "
    "(? , ? , ?)"

  # Delete an attachment from the attached thing
  DeleteSql = "DELETE FROM polymorphic_attachments WHERE "\
   "discriminator = ? AND discriminator_id = ?"

end
end

