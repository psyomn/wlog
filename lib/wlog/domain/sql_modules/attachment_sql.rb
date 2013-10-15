module Wlog
# The sql for attachments
# @author Simon Symeonidis
module AttachmentSql
  # The table name 
  TableName = "attachments"

  # Insert the file data into the database (NOTE wondering if small/big endian
  # will be affecting this...)
  InsertSql = "INSERT INTO #{Tablename} (filename, given_name, data) "\
    "values (?, ?, ?); "

  # Delete by id
  DeleteSql = "DELETE FROM #{Tablename} WHERE id = ?;" 

  # Select all the attachments
  SelectAllSql = "SELECT * FROM #{Tablename};"

  # Select an attachment given an id
  SelectSql = "SELECT * FROM #{Tablename} WHERE discriminator = ? AND "\
    "discriminator_id = ?;"
end
end
