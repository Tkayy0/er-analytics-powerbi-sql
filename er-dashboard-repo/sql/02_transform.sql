-- 02_transform.sql
-- Cleans the raw table and adds the derived columns the dashboard uses.
-- Everything downstream queries this view, not the raw table.
--
-- Choices made here:
--   * Identifying columns (patient_id, first initial, last name) are left out on purpose.
--     None of the analysis needs them.
--   * A satisfaction score of 0 is treated as "not rated", the same as a blank score.
--     Only scores of 1 to 10 count towards the average.
--   * A visit is a walk-in when the referral column is blank or the text 'None'.
--   * Age groups: Infancy 1-2, Early Childhood 3-6, Middle Childhood 7-12,
--     Teenager 13-18, Adult 19 and over.
--
-- Date functions (strftime) are SQLite. SQL Server equivalents:
--   YEAR(date), MONTH(date), DATEPART(hour, date), and
--   DATENAME(weekday, date) IN ('Saturday', 'Sunday') for weekends.

DROP VIEW IF EXISTS er_visits_clean;

CREATE VIEW er_visits_clean AS
SELECT
    date                                                        AS visit_datetime,
    CAST(strftime('%Y', date) AS INTEGER)                       AS visit_year,
    CAST(strftime('%m', date) AS INTEGER)                       AS visit_month,

    CASE WHEN CAST(strftime('%H', date) AS INTEGER) < 12
         THEN 'AM' ELSE 'PM' END                                AS visit_period,

    CASE WHEN strftime('%w', date) IN ('0', '6')
         THEN 'Weekend' ELSE 'Weekday' END                      AS week_type,

    CASE patient_gender
         WHEN 'M' THEN 'Male'
         WHEN 'F' THEN 'Female'
         ELSE 'Unknown' END                                     AS gender,

    patient_age                                                 AS age,

    CASE WHEN patient_age <= 2  THEN 'Infancy'
         WHEN patient_age <= 6  THEN 'Early Childhood'
         WHEN patient_age <= 12 THEN 'Middle Childhood'
         WHEN patient_age <= 18 THEN 'Teenager'
         ELSE 'Adult' END                                       AS age_group,

    CASE WHEN patient_age <= 10 THEN '0-10'
         WHEN patient_age <= 20 THEN '11-20'
         WHEN patient_age <= 30 THEN '21-30'
         WHEN patient_age <= 40 THEN '31-40'
         WHEN patient_age <= 50 THEN '41-50'
         WHEN patient_age <= 60 THEN '51-60'
         WHEN patient_age <= 70 THEN '61-70'
         ELSE '70+' END                                         AS age_band,   -- ages above 70, same label as the dashboard

    patient_race                                                AS race,

    CASE WHEN LOWER(TRIM(patient_admin_flag)) IN ('true', '1')
         THEN 'Administrative' ELSE 'Non-administrative' END    AS appointment_type,

    patient_waittime                                            AS wait_minutes,

    -- NULL when the visit was not rated (blank or 0); AVG() then skips it automatically
    CASE WHEN CAST(NULLIF(TRIM(patient_sat_score), '') AS INTEGER) > 0
         THEN CAST(TRIM(patient_sat_score) AS INTEGER) END      AS satisfaction_score,

    COALESCE(NULLIF(TRIM(department_referral), ''), 'None')     AS department_referral,

    CASE WHEN COALESCE(NULLIF(TRIM(department_referral), ''), 'None') = 'None'
         THEN 'Walk-in' ELSE 'Referred' END                     AS referral_type
FROM er_visits;
