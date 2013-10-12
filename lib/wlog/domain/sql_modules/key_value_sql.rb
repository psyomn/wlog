module Wlog
# Encapsulate the sql in only one part.
# @author Simon Symeonidis
module KeyValueSql
  # The table name of the log entries table
  TableName = "key_values"

  # Standard insert
  InsertSql = \
    "INSERT INTO #{TableName} (key,value) values (?,?);"
  # Standard delete
  DeleteSql = "DELETE FROM #{TableName} WHERE key = ? ;"

  # Standard update
  UpdateSql = "UPDATE #{TableName} SET value = ? WHERE key = ?;"
  
  # Select by key
  Select = "SELECT * FROM #{TableName} WHERE key = ? ;"
end
end
