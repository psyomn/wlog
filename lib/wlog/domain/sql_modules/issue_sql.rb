module Wlog
# Issue SQL 
# @author Simon Symeonidis
module IssueSql
  # The table name of the log entries table
  TableName = "issues"

  # Standard insert
  InsertSql = \
    "INSERT INTO #{TableName} "\
    "(description, reported_date, due_date, status) "\
    "values (?,?,?,?);"
  # Standard delete
  DeleteSql = "DELETE FROM #{TableName} WHERE id = ? ;"

  # Standard update
  UpdateSql = "UPDATE #{TableName} SET "\
    "description = ? , reported_date = ? , due_date = ? , status = ?"\
    "WHERE id = ?;"
  
  # Select by id
  SelectSql = "SELECT * FROM #{TableName} WHERE id = ? ;"

  # Select all the issues (which are not archived)
  SelectAllSql = "SELECT * FROM #{TableName} WHERE status <> 3; "

  # Select issues that are finished
  SelectFinishedSql = "SELECT * FROM #{TableName} WHERE status = 2"
end
end

