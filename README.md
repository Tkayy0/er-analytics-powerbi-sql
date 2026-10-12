# Emergency Room Analytics Dashboard (Power BI, DAX and SQL)

An interactive Power BI dashboard analysing 9,216 emergency room patient visits. The data is loaded and prepared in Power Query, the metrics are built as DAX measures, and the repository also includes SQL versions of the dashboard's calculations. The dashboard surfaces key operational metrics and breaks the data down by department referral, age group, gender and patient race, including a heatmap of which age and race groups experienced the longest waits, so a non-technical reader can spot patterns at a glance.

> **Sample data.** This project uses a sample practice dataset, not real hospital data. Nothing here should be read as a finding about real patients.

![Emergency room dashboard in Power BI]
<img width="1280" height="720" alt="dashboard" src="https://github.com/user-attachments/assets/bb780a39-84ee-4e87-bb98-35be276d320c" />


## Demo
<img width="800" height="450" alt="Demo" src="https://github.com/user-attachments/assets/89ff4ba1-6eee-447b-828c-7eb02e15cba2" />


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
- Visits by year and by month, with the highest and lowest points marked, and weekday vs weekend
- A heatmap of average wait time or average satisfaction by patient race and age band, switched with a slicer

<img width="902" height="426" alt="heatmap" src="https://github.com/user-attachments/assets/f552e257-3038-404f-bed6-2308301c6091" />

## How it is built

**Power Query** (`power_query/patients_dataset.m`). Loads the CSV, keeps the AM or PM marker from the date text, converts the date, merges the first initial and last name into one column, and sets the data types.

**DAX** (`dax/measures.dax`). The model has a calendar table, a field parameter that switches the heatmap between average wait time and average satisfaction, calculated columns for age group and age band, and measures for each figure on the page, including the highest and lowest point markers on the trend charts.

**SQL** (`sql/`). The same calculations written in SQL against the same data. They reproduce the dashboard's figures from the raw CSV, so they work as a cross-check on the DAX and as a version of the logic for anyone working in a database. Run them in order:

| File | What it does |
|---|---|
| `01_create_table.sql` | Creates the raw `er_visits` table, one row per visit, matching the CSV columns |
| `02_transform.sql` | Builds a cleaned view with derived columns: age group, age band, week type, AM or PM, referral type, and a satisfaction score that is blank for unrated visits |
| `03_kpis.sql` | The headline figures in the table above |
| `04_breakdowns.sql` | One query per chart: department, age group, gender, race, year, month, week type, AM or PM |
| `05_heatmap.sql` | Average wait and satisfaction for every race and age band combination, in long and grid form |

Definitions used in both the DAX and the SQL:

- **Unrated visits.** A satisfaction score of 0 is treated the same as a blank one.
- **Walk-ins.** A visit counts as a walk-in when the referral column is `None`.
- **Age groups.** Infancy is 1 to 2, Early Childhood 3 to 6, Middle Childhood 7 to 12, Teenager 13 to 18 and Adult 19 and over.
- **Age bands** for the heatmap are 0-10, 11-20 and so on up to 61-70, then 70+ for everyone older.
- **Weekend** means Saturday or Sunday.

The SQL leaves out the patient ID and name columns, because none of the analysis needs them.

## Checking the SQL

The KPI queries return the same headline figures as the dashboard. The department, age group, year, month and weekday vs weekend counts also match the dashboard's charts.

## Data

[Data](https://drive.google.com/file/d/1h7SHRhKeP9jP1axeYRtKg-TE3UldhiYx/view)

The raw CSV is not included in this repository. It contains patient ID and name columns. To run the queries, get the file from its source and save it as `data/Hospital_ER.csv`.

## Running the SQL

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

Working through the full path from raw data to a finished dashboard: ingesting and preparing the data, modelling it with DAX, and presenting it in Power BI for a reader who is not technical. The SQL adds a second implementation of the same logic, which is a useful check that the numbers are right.

## Limitations

- It is a sample dataset, so the patterns in it are not real clinical or operational findings.
- Only about a quarter of visits have a satisfaction rating, so the 5.47 average describes a minority of visits.

## Related

- GitHub: https://github.com/keeganchinyenze
- LinkedIn: https://www.linkedin.com/in/keeganchinyenze
