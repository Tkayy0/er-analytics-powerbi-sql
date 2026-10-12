-- 01_create_table.sql
-- Raw table: one row per emergency room visit.
-- Columns match Hospital_ER.csv exactly (including the source file's spelling of "inital").
--
-- Written and tested for SQLite. For SQL Server, swap TEXT for VARCHAR(100) and
-- INTEGER for INT; everything else in this file is unchanged.

DROP TABLE IF EXISTS er_visits;

CREATE TABLE er_visits (
    date                  TEXT,      -- visit timestamp, e.g. 2020-03-20 08:47:01
    patient_id            TEXT,
    patient_gender        TEXT,      -- M, F or NC
    patient_age           INTEGER,
    patient_sat_score     INTEGER,   -- 0 to 10, blank when no score was given
    patient_first_inital  TEXT,
    patient_last_name     TEXT,
    patient_race          TEXT,
    patient_admin_flag    TEXT,      -- 'true' or 'false' (administrative appointment)
    patient_waittime      INTEGER,   -- minutes
    department_referral   TEXT       -- referring department, or the text 'None' for walk-ins
);

-- Load the CSV (run these in the sqlite3 shell, not as part of the script):
--   .mode csv
--   .import --skip 1 data/Hospital_ER.csv er_visits
--
-- DB Browser for SQLite alternative:
--   File > Import > Table from CSV file..., choose the existing er_visits table.
--
-- SQL Server alternative:
--   BULK INSERT er_visits FROM 'C:\path\Hospital_ER.csv'
--   WITH (FORMAT = 'CSV', FIRSTROW = 2, KEEPNULLS);
