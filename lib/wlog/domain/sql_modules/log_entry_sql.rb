module Wlog
# Encapsulate the sql in only one part.
# @author Simon Symeonidis
module LogEntrySql
  # The table name of the log entries table
  TableName = "log_entries"

  # Standard insert
  InsertSql = \
    "INSERT INTO #{TableName} (description,date,issue_id) values (?,?,?);"
  # Standard delete
  DeleteSql = "DELETE FROM #{TableName} WHERE id = ? ;"

  # Standard select all
  SelectAll = "SELECT * FROM #{TableName} ORDER BY date ASC;"
  
  # Standard update
  UpdateSql = "UPDATE #{TableName} SET description = ? WHERE id = ?;"
  
  # select all with a limit
  SelectAllLimit = \
    "SELECT * FROM #{TableName} WHERE date >="\
    " #{Time.now.to_i - 604800 - 24 * 60 * 60} ORDER BY date ASC"
  
  # Select by id
  Select = "SELECT * FROM #{TableName} WHERE id = ? ;"
  
  # Select by id
  SelectAllByIssue = "SELECT * FROM #{TableName} WHERE issue_id = ? ;"

  # Select by a regex like /.../i
  SelectDescriptionLike = \
    "SELECT * FROM #{TableName} WHERE description LIKE ?;"
end
end
