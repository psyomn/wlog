--$ Migration to turntables. This is the initial configuration of the database
--$ for this application.

-- author: Simon Symeonidis 
--
-- Please follow plurals like this: 
--   class Issue  -> issues; 
--   class Person -> people;
-- 

-- An issue has many log entries
CREATE TABLE issues (
  id            INTEGER PRIMARY KEY AUTOINCREMENT,
  description   TEXT, 
  reported_date INTEGER, 
  due_date      INTEGER, 
  status        INTEGER
);

-- Where to store the log entries.
CREATE TABLE log_entries (
  id            INTEGER PRIMARY KEY AUTOINCREMENT,
  description   TEXT, 
  date          DATETIME, 
  issue_id      INTEGER
);

-- We can add attachments to stuff.
CREATE TABLE attachments (
  id         INTEGER PRIMARY KEY AUTOINCREMENT,
  filename   TEXT, 
  given_name TEXT,
  data       BLOB
);

-- Create the key value table
CREATE TABLE key_values (
  key TEXT,
  value TEXT
);

-- A polymorphic relationship for attachments. So pretty much anything that
-- wants to have something attached, uses the discriminator in order to 
-- specify itself, as well as its id. 
CREATE TABLE polymorphic_attachments (
  discriminator    TEXT, 
  discriminator_id INTEGER, 
  attachment_id    INTEGER
);

