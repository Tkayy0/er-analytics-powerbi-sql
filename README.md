# Emergency Room Analytics Dashboard (SQL and Power BI)

An interactive Power BI dashboard analysing 9,216 emergency room patient visits, with SQL queries to extract and transform the data before it is visualised. The dashboard surfaces key operational metrics and breaks the data down by department referral, age group, gender and patient race, including a heatmap of which age and race groups experienced the longest waits, so a non-technical reader can spot patterns at a glance.

> **Sample data.** This project uses a sample practice dataset, not real hospital data. Nothing here should be read as a finding about real patients.

![Emergency room dashboard in Power BI](images/dashboard.png)

## Headline figures

| Metric | Value |
|---|---|
| Total patient visits | 9,216 |
| Average wait time | 35.26 minutes |
| Average satisfaction score | 5.47 (rated visits only, see note below) |
| Visits with no satisfaction rating | 75.10% |
| Referred vs walk-in patients | 41.41% vs 58.59% |
| Administrative vs non-administrative appointments | 50.04% vs 49.96% |

The visits run from 1 April 2019 to 30 October 2020.

**How satisfaction is calculated.** Most visits have no usable score: 6,699 are blank and 222 are recorded as 0. The dashboard treats both as "not rated", which is where the 75.10% comes from, and averages only the scores from 1 to 10.

## What the dashboard shows

- Total visits, average wait time, average satisfaction and the share of unrated visits
- Referred vs walk-in patients, with an AM and PM filter
- Visits by department referral
- Visits by age group (Infancy, Early Childhood, Middle Childhood, Teenager, Adult)
- Visits by gender
- Visits by year, by month, and weekday vs weekend
- A heatmap of average wait time (or average satisfaction) by patient race and age band

![Heatmap of average wait time by age group and patient race](images/heatmap.png)

## The SQL

The queries in `sql/` take the raw visit data and shape it into the figures the dashboard needs. Run them in order.

| File | What it does |
|---|---|
| `01_create_table.sql` | Creates the raw `er_visits` table, one row per visit, matching the CSV columns |
| `02_transform.sql` | Builds a cleaned view with derived columns: age group, age band, week type, AM or PM, referral type, and a satisfaction score that is blank for unrated visits |
| `03_kpis.sql` | The headline figures in the table above |
| `04_breakdowns.sql` | One query per chart: department, age group, gender, race, year, month, week type, AM or PM |
| `05_heatmap.sql` | Average wait and satisfaction for every race and age band combination, in long and grid form |

Decisions made in the transform step:

- **Identifying columns are left out.** Patient ID, first initial and last name are not carried into the cleaned view, because none of the analysis needs them.
- **Unrated visits.** A satisfaction score of 0 is treated the same as a blank one.
- **Walk-ins.** A visit counts as a walk-in when the referral column is blank or the text `None`.
- **Age groups.** Infancy is 1 to 2, Early Childhood 3 to 6, Middle Childhood 7 to 12, Teenager 13 to 18 and Adult 19 and over.

## Checking the SQL

The KPI queries return the same headline figures as the dashboard. The department, age group, year, month and weekday vs weekend counts also match the dashboard's charts.

## Data

<!-- ADD: where the dataset came from and its licence, for example "Source: <name and link>. Used under <licence>." -->

The raw CSV is not included in this repository. It contains patient ID and name columns, which is another reason the SQL leaves them out of the cleaned view. To run the queries, get the file from its source and save it as `data/Hospital_ER.csv`.

## Running the queries

The SQL is written and tested for SQLite, which needs no server. In the `sqlite3` shell:

```
sqlite3 er.db
.read sql/01_create_table.sql
.mode csv
.import --skip 1 data/Hospital_ER.csv er_visits
.read sql/02_transform.sql
.read sql/03_kpis.sql
```

Or use DB Browser for SQLite: create the database, run `01_create_table.sql`, import the CSV into `er_visits` with File > Import, then run the other files. The comments in `01_create_table.sql` and `02_transform.sql` list the small changes needed for SQL Server.

## What I practised

Working through the full path from raw data to a finished dashboard: ingesting the data, shaping and modelling it with SQL, and presenting it in Power BI for a reader who is not technical.

## Limitations

- It is a sample dataset, so the patterns in it are not real clinical or operational findings.
- Only about a quarter of visits have a satisfaction rating, so the 5.47 average describes a minority of visits.

## Related

- GitHub: https://github.com/keeganchinyenze
- LinkedIn: https://www.linkedin.com/in/keeganchinyenze
