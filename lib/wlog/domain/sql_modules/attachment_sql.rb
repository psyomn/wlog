module Wlog
# The sql for attachments
# @author Simon Symeonidis
module AttachmentSql
  # The table name 
  TableName = "attachments"

  # Insert the file data into the database (NOTE wondering if small/big endian
  # will be affecting this...)
  InsertSql = "INSERT INTO #{TableName} (filename, given_name, data) "\
    "values (?, ?, ?); "

  # Delete by id
  DeleteSql = "DELETE FROM #{TableName} WHERE discriminator = ? AND "\
    "discriminator_id = ?;" 

  # Select an attachment given an id
  SelectSql = "SELECT * FROM #{TableName} WHERE id = ? "
end
end

