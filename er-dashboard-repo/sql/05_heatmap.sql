-- 05_heatmap.sql
-- Data behind the heatmap: average wait time and average satisfaction
-- for every combination of patient race and age band.

-- Long format: one row per race and age band. This is the shape Power BI's matrix visual wants.
SELECT
    race,
    age_band,
    COUNT(*)                                                    AS visits,
    ROUND(AVG(CAST(wait_minutes AS FLOAT)), 2)                  AS avg_wait_minutes,
    ROUND(AVG(CAST(satisfaction_score AS FLOAT)), 2)            AS avg_satisfaction
FROM er_visits_clean
GROUP BY race, age_band
ORDER BY race, MIN(age);

-- Wide format: the same average wait times with one column per age band, so the grid
-- reads like the heatmap. Cells with no visits come back empty.
SELECT
    race,
    ROUND(AVG(CASE WHEN age_band = '0-10'  THEN CAST(wait_minutes AS FLOAT) END), 1) AS "0-10",
    ROUND(AVG(CASE WHEN age_band = '11-20' THEN CAST(wait_minutes AS FLOAT) END), 1) AS "11-20",
    ROUND(AVG(CASE WHEN age_band = '21-30' THEN CAST(wait_minutes AS FLOAT) END), 1) AS "21-30",
    ROUND(AVG(CASE WHEN age_band = '31-40' THEN CAST(wait_minutes AS FLOAT) END), 1) AS "31-40",
    ROUND(AVG(CASE WHEN age_band = '41-50' THEN CAST(wait_minutes AS FLOAT) END), 1) AS "41-50",
    ROUND(AVG(CASE WHEN age_band = '51-60' THEN CAST(wait_minutes AS FLOAT) END), 1) AS "51-60",
    ROUND(AVG(CASE WHEN age_band = '61-70' THEN CAST(wait_minutes AS FLOAT) END), 1) AS "61-70",
    ROUND(AVG(CASE WHEN age_band = '70+'   THEN CAST(wait_minutes AS FLOAT) END), 1) AS "70+"
FROM er_visits_clean
GROUP BY race
ORDER BY race;
