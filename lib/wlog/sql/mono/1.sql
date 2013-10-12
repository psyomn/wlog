--$ Migration to turntables. This is the initial configuration of the database
--$ for this application.

-- An issue has many log entries
CREATE TABLE issues (
  id   INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT
);

-- Where to store the log entries.
CREATE TABLE log_entries (
  id            INTEGER PRIMARY KEY AUTOINCREMENT,
  description   TEXT, 
  date          DATETIME, 
  issue_id      INTEGER,
  attachment_id INTEGER,
  FOREIGN KEY(issue_id) REFERENCES issues(id) ON DELETE CASCADE,
  FOREIGN KEY(attachment_id) REFERENCES attachments(id) ON DELETE CASCADE
);

-- We can add attachments to stuff.
CREATE TABLE attachments (
  id         INTEGER PRIMARY KEY AUTOINCREMENT,
  filename   TEXT, 
  given_name TEXT
);


