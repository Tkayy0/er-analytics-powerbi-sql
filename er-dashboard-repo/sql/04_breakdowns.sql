-- 04_breakdowns.sql
-- One query per chart on the dashboard. Each returns visit counts, share of all visits,
-- average wait and average satisfaction (rated visits only).

-- 1. Visits by department referral ('None' means walk-in)
SELECT
    department_referral,
    COUNT(*)                                                    AS visits,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2)          AS pct_of_visits,
    ROUND(AVG(CAST(wait_minutes AS FLOAT)), 2)                  AS avg_wait_minutes,
    ROUND(AVG(CAST(satisfaction_score AS FLOAT)), 2)            AS avg_satisfaction
FROM er_visits_clean
GROUP BY department_referral
ORDER BY visits DESC;

-- 2. Visits by age group (youngest to oldest)
SELECT
    age_group,
    COUNT(*)                                                    AS visits,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2)          AS pct_of_visits,
    ROUND(AVG(CAST(wait_minutes AS FLOAT)), 2)                  AS avg_wait_minutes,
    ROUND(AVG(CAST(satisfaction_score AS FLOAT)), 2)            AS avg_satisfaction
FROM er_visits_clean
GROUP BY age_group
ORDER BY MIN(age);

-- 3. Visits by gender
SELECT
    gender,
    COUNT(*)                                                    AS visits,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2)          AS pct_of_visits,
    ROUND(AVG(CAST(wait_minutes AS FLOAT)), 2)                  AS avg_wait_minutes,
    ROUND(AVG(CAST(satisfaction_score AS FLOAT)), 2)            AS avg_satisfaction
FROM er_visits_clean
GROUP BY gender
ORDER BY visits DESC;

-- 4. Visits by race
SELECT
    race,
    COUNT(*)                                                    AS visits,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2)          AS pct_of_visits,
    ROUND(AVG(CAST(wait_minutes AS FLOAT)), 2)                  AS avg_wait_minutes,
    ROUND(AVG(CAST(satisfaction_score AS FLOAT)), 2)            AS avg_satisfaction
FROM er_visits_clean
GROUP BY race
ORDER BY visits DESC;

-- 5. Visits by year
SELECT visit_year, COUNT(*) AS visits
FROM er_visits_clean
GROUP BY visit_year
ORDER BY visit_year;

-- 6. Visits by calendar month (all years combined)
SELECT visit_month, COUNT(*) AS visits
FROM er_visits_clean
GROUP BY visit_month
ORDER BY visit_month;

-- 7. Weekday vs weekend
SELECT
    week_type,
    COUNT(*)                                                    AS visits,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2)          AS pct_of_visits
FROM er_visits_clean
GROUP BY week_type;

-- 8. AM vs PM
SELECT
    visit_period,
    COUNT(*)                                                    AS visits,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2)          AS pct_of_visits
FROM er_visits_clean
GROUP BY visit_period;
