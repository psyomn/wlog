--$ Add time logging for log_entries for version 1.0.5

ALTER TABLE log_entries ADD COLUMN timelog BIGINT;

