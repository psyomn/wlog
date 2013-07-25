module Wlog
# @author Simon Symeonidis
# Encapsulate the sql in only one part.
module LogEntrySql

  TableName             = "log_entries"

  InsertSql             = "INSERT INTO #{TableName} (description,date) values (?,?);"
  DeleteSql             = "DELETE FROM #{TableName} WHERE id = ? ;"
  SelectAll             = "SELECT * FROM #{TableName} ORDER BY date ASC;"
  UpdateSql             = "UPDATE #{TableName} SET description = ? WHERE id = ?;"
  SelectAllLimit        = "SELECT * FROM #{TableName} WHERE date >= #{Time.now.to_i - 604800 - 24 * 60 * 60} ORDER BY date ASC"
  Select                = "SELECT * FROM #{TableName} WHERE id = ? ;"
  SelectDescriptionLike = "SELECT * FROM #{TableName} WHERE description LIKE ?;"

end
end
