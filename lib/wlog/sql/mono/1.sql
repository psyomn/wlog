--$ Started using turntables in order to manage different tables on this gem.
--$ Let us see how that goes. 

-- Where to store the log entries.
CREATE TABLE log_entries (
  id          INTEGER PRIMARY KEY AUTOINCREMENT,
  description TEXT, 
  date        DATETIME
);


