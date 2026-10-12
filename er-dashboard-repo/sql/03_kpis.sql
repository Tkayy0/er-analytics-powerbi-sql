-- 03_kpis.sql
-- Headline figures shown at the top of the dashboard.
-- Expected results on the sample dataset:
--   total_visits 9216 | avg_wait_minutes 35.26 | avg_satisfaction 5.47 | pct_not_rated 75.10
--   pct_referred 41.41 | pct_walk_in 58.59 | pct_administrative 50.04 | pct_non_administrative 49.96

SELECT
    COUNT(*)                                                                        AS total_visits,
    ROUND(AVG(CAST(wait_minutes AS FLOAT)), 2)                                      AS avg_wait_minutes,
    -- satisfaction_score is NULL for unrated visits, so AVG only uses rated ones
    ROUND(AVG(CAST(satisfaction_score AS FLOAT)), 2)                                AS avg_satisfaction,
    ROUND(100.0 * SUM(CASE WHEN satisfaction_score IS NULL THEN 1 ELSE 0 END)
          / COUNT(*), 2)                                                            AS pct_not_rated,
    ROUND(100.0 * SUM(CASE WHEN referral_type = 'Referred' THEN 1 ELSE 0 END)
          / COUNT(*), 2)                                                            AS pct_referred,
    ROUND(100.0 * SUM(CASE WHEN referral_type = 'Walk-in' THEN 1 ELSE 0 END)
          / COUNT(*), 2)                                                            AS pct_walk_in,
    ROUND(100.0 * SUM(CASE WHEN appointment_type = 'Administrative' THEN 1 ELSE 0 END)
          / COUNT(*), 2)                                                            AS pct_administrative,
    ROUND(100.0 * SUM(CASE WHEN appointment_type = 'Non-administrative' THEN 1 ELSE 0 END)
          / COUNT(*), 2)                                                            AS pct_non_administrative
FROM er_visits_clean;
