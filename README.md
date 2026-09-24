# Data Analyst Job Market Analysis

## Introduction

This project explores the data analyst job market using SQL and PostgreSQL. I analyzed job postings to investigate salary levels, skill demand, and the relationship between skills, demand, and compensation.

The project was completed as part of my development in data analytics, with a particular focus on working with relational data, joins, filtering, aggregation, and analytical SQL.

The SQL queries used for the analysis can be found in the [`project_sql`](project_sql/) folder.

---

## Background

As part of my transition into data analytics, I wanted to use SQL to investigate practical questions about the data analyst job market rather than only practice individual SQL concepts.

Using a dataset containing job postings, salaries, locations, companies, and required skills, I explored which data analyst roles pay the most, which skills are most frequently requested, and which skills are associated with higher salaries.

I used [Luke Barousse's SQL for Data Analytics course](https://www.youtube.com/watch?v=MOzEvNYvbik) as the learning framework for this project. I rebuilt the queries while working through the course and made modifications to some of the analyses based on my own questions and approach.

### Questions I wanted to answer

1. What are the top-paying data analyst jobs?
2. What skills are required for these top-paying jobs?
3. What skills are most in demand for data analysts?
4. Which skills are associated with higher salaries?
5. Which skills combine relatively high demand with higher salaries?

---

## Tools I Used

* **SQL** — Used to query, filter, join, aggregate, and analyze the data.
* **PostgreSQL** — Database management system used for the analysis.
* **Visual Studio Code** — Used to write and manage SQL queries.
* **pgAdmin** — Used to interact with and inspect the PostgreSQL database.
* **Git & GitHub** — Used for version control and hosting the project.

---

# The Analysis

## 1. Top-Paying Data Analyst Jobs

### Question

**What are the top-paying remote data analyst jobs?**

I filtered the job postings for Data Analyst roles with a specified annual salary and a remote location listed as `Anywhere`, then sorted the results by salary.

### SQL Query

```sql
SELECT
    job_id,
    job_title,
    company_dim.name AS company_name,
    job_location,
    salary_year_avg,
    job_schedule_type
FROM
    job_postings_fact
LEFT JOIN
    company_dim
ON
    job_postings_fact.company_id = company_dim.company_id
WHERE
    job_title_short = 'Data Analyst'
    AND
    job_location = 'Anywhere'
    AND
    salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC
LIMIT 10;
```

### Results

| Job Title                               | Company                            | Location | Average Salary | Schedule  |
| --------------------------------------- | ---------------------------------- | -------- | -------------: | --------- |
| Data Analyst                            | Mantys                             | Anywhere |       $650,000 | Full-time |
| Director of Analytics                   | Meta                               | Anywhere |       $336,500 | Full-time |
| Associate Director- Data Insights       | AT&T                               | Anywhere |    $255,829.50 | Full-time |
| Data Analyst, Marketing                 | Pinterest Job Advertisements       | Anywhere |       $232,423 | Full-time |
| Data Analyst (Hybrid/Remote)            | Uclahealthcareers                  | Anywhere |       $217,000 | Full-time |
| Principal Data Analyst (Remote)         | SmartAsset                         | Anywhere |       $205,000 | Full-time |
| Director, Data Analyst - HYBRID         | Inclusively                        | Anywhere |       $189,309 | Full-time |
| Principal Data Analyst, AV Performance… | Motional                           | Anywhere |       $189,000 | Full-time |
| Principal Data Analyst                  | SmartAsset                         | Anywhere |       $186,000 | Full-time |
| ERM Data Analyst                        | Get It Recruit - Information Tech… | Anywhere |       $184,000 | Full-time |

![Query 1 results](assets/Query%201.png)

### Key observations

* The $650,000 Data Analyst role at Mantys is a clear outlier, almost double the next highest salary ($336,500 at Meta). It may reflect an unusual posting or a data-entry issue, so it should be treated with caution.
* Excluding that outlier, the remaining nine postings range from $184,000 to $336,500.
* Six of the ten titles include a seniority or leadership term (Director, Associate Director, Principal), which suggests seniority contributes to the highest salaries. Four plain "Data Analyst" titles also make the list, so senior titles are not the only route to high pay.
* All ten postings are full-time roles.

---

## 2. Skills for Top-Paying Jobs

### Question

**What skills are required for the top-paying data analyst jobs?**

I first identified the 10 highest-paying remote Data Analyst positions, then joined those results with the job-skill relationship table and skills table.

I used `STRING_AGG()` to combine the skills associated with each job into a single row, making the results easier to read than returning one row for every individual job-skill relationship.

### SQL Query

```sql
WITH top_paying_jobs AS (
    SELECT
        job_id,
        job_title,
        company_dim.name AS company_name,
        salary_year_avg
    FROM
        job_postings_fact
    LEFT JOIN
        company_dim
    ON
        job_postings_fact.company_id = company_dim.company_id
    WHERE
        job_location ILIKE 'Anywhere'
        AND
        job_title_short = 'Data Analyst'
        AND
        salary_year_avg IS NOT NULL
    ORDER BY
        salary_year_avg DESC
    LIMIT 10
)
SELECT
    top_paying_jobs.job_id,
    top_paying_jobs.job_title,
    top_paying_jobs.company_name,
    top_paying_jobs.salary_year_avg,
    STRING_AGG(skills_dim.skills, ', ') AS skills
FROM
    top_paying_jobs
JOIN
    skills_job_dim
ON
    top_paying_jobs.job_id = skills_job_dim.job_id
JOIN
    skills_dim
ON
    skills_job_dim.skill_id = skills_dim.skill_id
GROUP BY
    top_paying_jobs.job_id,
    top_paying_jobs.job_title,
    top_paying_jobs.company_name,
    top_paying_jobs.salary_year_avg
ORDER BY
    salary_year_avg DESC;
```

### Results

| Job Title                               | Company                            |      Salary | Skills                                                                                                  |
| --------------------------------------- | ---------------------------------- | ----------: | ------------------------------------------------------------------------------------------------------- |
| Associate Director- Data Insights       | AT&T                               | $255,829.50 | sql, python, r, azure, databricks, aws, pandas, pyspark, jupyter, excel, tableau, power bi, powerpoint  |
| Data Analyst, Marketing                 | Pinterest Job Advertisements       |    $232,423 | sql, python, r, hadoop, tableau                                                                         |
| Data Analyst (Hybrid/Remote)            | Uclahealthcareers                  |    $217,000 | sql, crystal, oracle, tableau, flow                                                                     |
| Principal Data Analyst (Remote)         | SmartAsset                         |    $205,000 | sql, python, go, snowflake, pandas, numpy, excel, tableau, gitlab                                       |
| Director, Data Analyst - HYBRID         | Inclusively                        |    $189,309 | sql, python, azure, aws, oracle, snowflake, tableau, power bi, sap, jenkins, bitbucket, atlassian, jira, confluence |
| Principal Data Analyst, AV Performance… | Motional                           |    $189,000 | sql, python, r, git, bitbucket, atlassian, jira, confluence                                             |
| Principal Data Analyst                  | SmartAsset                         |    $186,000 | sql, python, go, snowflake, pandas, numpy, excel, tableau, gitlab                                       |
| ERM Data Analyst                        | Get It Recruit - Information Tech… |    $184,000 | sql, python, r                                                                                          |

![Query 2 results](assets/Query%202.png)

### Key observations

* Only eight rows are returned rather than ten. The query uses an inner join to the skills tables, so top-paying postings with no linked skills are dropped. Queries 1 and 2 use the same filters and therefore start from the same ten postings; the two that do not appear here, the Mantys ($650,000) and Meta ($336,500) roles, have no skills linked.
* SQL appears in every posting shown, Python in seven of the eight, and Tableau in six. These three form the common core of the highest-paying roles.
* Beyond the core, the higher-paying postings add cloud and data-platform tools (Azure, AWS, Snowflake, Databricks, Hadoop) and, in some cases, engineering and collaboration tools (Git, Bitbucket, GitLab, Jira, Confluence). Skill lists range from three skills (ERM) to more than a dozen (AT&T, Inclusively), so a very long list is not a requirement for a high salary.

---

## 3. Most In-Demand Skills for Data Analysts

### Question

**What are the most in-demand skills for data analysts?**

I joined job postings with the job-skill relationship table and skills table, then counted the number of job postings associated with each skill.

I initially approached this analysis using a CTE to separate the job-skill relationships from the final aggregation. I then rebuilt the query using direct joins after becoming more comfortable with how the tables relate to each other.

### SQL Query

```sql
SELECT
    skills,
    COUNT(job_postings_fact.job_id) AS skill_demand
FROM
    job_postings_fact
JOIN
    skills_job_dim
ON
    job_postings_fact.job_id = skills_job_dim.job_id
JOIN
    skills_dim
ON
    skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst'
GROUP BY
    skills
ORDER BY
    skill_demand DESC
LIMIT 5;
```

### Results

| Skill    | Demand Count |
| -------- | -----------: |
| sql      |       92,628 |
| excel    |       67,031 |
| python   |       57,326 |
| tableau  |       46,554 |
| power bi |       39,468 |

![Query 3 results](assets/Query%203.png)

### Key observations

* SQL is the most requested skill by a clear margin: 92,628 postings, roughly 38% more than Excel and more than double Power BI.
* Excel is still the second most requested skill, ahead of Python, so spreadsheet skills remain a core expectation for data analyst roles.
* Two of the top five skills are visualization tools, with Tableau (46,554) requested more often than Power BI (39,468). Together, SQL, Excel, Python, and a BI tool make up the core toolkit.

Note: a single posting can list several skills, so these counts overlap and do not add up to the number of postings.

---

## 4. Skills Associated With Higher Salaries

### Question

**Which skills are associated with higher salaries?**

I calculated the average annual salary associated with each skill among Data Analyst job postings with specified salaries.

Unlike the first two analyses, this query does not restrict the results to remote positions. The goal here was to examine the relationship between skills and salary across the available Data Analyst postings.

### SQL Query

```sql
SELECT
    skills,
    ROUND(AVG(salary_year_avg), 0) AS salary
FROM
    job_postings_fact
JOIN
    skills_job_dim
ON
    job_postings_fact.job_id = skills_job_dim.job_id
JOIN
    skills_dim
ON
    skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst'
    AND
    salary_year_avg IS NOT NULL
GROUP BY
    skills
ORDER BY
    salary DESC
LIMIT 5;
```

### Results

| Skill     | Average Salary |
| --------- | -------------: |
| svn       |       $400,000 |
| solidity  |       $179,000 |
| couchbase |       $160,515 |
| datarobot |       $155,486 |
| golang    |       $155,000 |

![Query 4 results](assets/Query%204.png)

### Key observations

* The highest-paying skills are specialized and niche: version control (SVN), smart-contract development (Solidity), a NoSQL database (Couchbase), an automated machine learning platform (DataRobot), and Go.
* SVN's $400,000 average is far above everything else. The query has no minimum number of postings, so averages like this can be driven by a very small number of postings and should not be treated as a reliable benchmark.
* None of these skills appear in the most in-demand list from Query 3. The highest-paying skills and the most requested skills are almost entirely different, which is what motivated the final query.

> **Note:** A higher average salary associated with a skill does not necessarily mean that the skill itself causes higher salaries. The query identifies an association within the job-posting data.

---

## 5. Skills Combining Demand and Salary

### Question

**Which skills combine relatively high demand with higher salaries?**

I combined skill demand and average salary into one analysis. I focused on remote Data Analyst positions with specified salaries and used `HAVING` to exclude skills appearing in fewer than 11 job-skill relationships.

The results were then sorted by average salary, with skill demand used as a secondary sort.

### SQL Query

```sql
SELECT
    skills_dim.skill_id,
    skills,
    ROUND(AVG(job_postings_fact.salary_year_avg), 0) AS avg_salary,
    COUNT(job_postings_fact.job_id) AS skill_demand
FROM
    job_postings_fact
JOIN
    skills_job_dim
ON
    job_postings_fact.job_id = skills_job_dim.job_id
JOIN
    skills_dim
ON
    skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst'
    AND
    salary_year_avg IS NOT NULL
    AND
    job_work_from_home IS TRUE
GROUP BY
    skills_dim.skill_id
HAVING
    COUNT(job_postings_fact.job_id) > 10
ORDER BY
    avg_salary DESC,
    skill_demand DESC
LIMIT 25;
```

### Results

The table shows the ten highest average salaries. The full output is in the screenshot below.

| Skill      | Demand Count | Average Salary |
| ---------- | -----------: | -------------: |
| go         |           27 |       $115,320 |
| confluence |           11 |       $114,210 |
| hadoop     |           22 |       $113,193 |
| snowflake  |           37 |       $112,948 |
| azure      |           34 |       $111,225 |
| bigquery   |           13 |       $109,654 |
| aws        |           32 |       $108,317 |
| java       |           17 |       $106,906 |
| ssis       |           12 |       $106,683 |
| jira       |           20 |       $104,918 |

![Query 5 results](assets/Query%205.png)

### Key observations

* Average salaries are tightly clustered: the top ten span only about $10,000 ($104,918 to $115,320), and every skill in the screenshot falls between roughly $99,000 and $115,000. Differences between individual skills are small.
* The most requested skills sit slightly lower on salary. Python (236 postings, $101,397), Tableau (230, $99,288), and R (148, $100,499) have roughly 5 to 9 times the demand of Go, with averages about $14,000 to $16,000 below it.
* Cloud and data-platform skills offer the best balance: Snowflake (37 postings, $112,948), Azure (34, $111,225), and AWS (32, $108,317) combine above-average salaries with solid demand. Go has the highest average ($115,320) but only 27 postings.
* `sas` appears twice with identical demand and salary figures (skill IDs 186 and 7), because two separate skill records share the same name. Grouping by `skill_id` keeps them separate.

Note: demand counts here are much smaller than in Query 3 because this query only counts remote postings with a listed salary.

---

# What I Learned

This project helped me develop a stronger understanding of how SQL can be used to analyze relational data.

### Joins and table relationships

One of the most important things I learned was how joins affect the grain of a result set.

The `skills_job_dim` table acts as a bridge between job postings and skills. Joining it to `job_postings_fact` changes the grain from individual job postings to job-skill relationships.

Understanding this made it easier to reason about why a single `job_id` can appear multiple times after a join without necessarily representing duplicate data.

### Aggregation

I used `GROUP BY`, `COUNT()`, and `AVG()` to summarize job and skill data.

I also learned the difference between filtering individual rows with `WHERE` and filtering aggregated groups with `HAVING`.

### Primary keys and grouping

While working with the skills data, I noticed that grouping by `skills` could combine records that had the same displayed skill name.

Grouping by `skills_dim.skill_id`, the primary key, preserves each distinct skill record instead. This is visible in the final analysis, where `sas` appears twice under two different skill IDs.

This helped reinforce the importance of understanding the underlying data model rather than relying only on the values being displayed.

### CTEs and query structure

I initially found CTEs useful for breaking complex problems into smaller steps. As I became more comfortable with joins and table relationships, I found myself naturally writing some of the same queries directly across multiple tables.

For example, I initially used a CTE for the in-demand skills analysis before rebuilding the query using direct joins.

### Translating questions into SQL

The project helped me move beyond thinking about SQL as individual commands and instead think about the relationship between the analytical question and the structure of the query:

**question → tables → relationships → filters → grouping → aggregation → result**

---

# Conclusions

## Key Insights

### Top-paying jobs

The top ten remote Data Analyst postings all pay at least $184,000, with a wide spread up to $336,500 and a single $650,000 outlier. Six of the ten titles carry a seniority or leadership label (Director, Associate Director, Principal), so the highest salaries appear to reflect seniority as well as the analyst role itself, although four plain Data Analyst titles also make the list.

### Skills required by top-paying jobs

SQL appears in every top-paying posting returned, Python in seven of eight, and Tableau in six. Higher-paying roles often add cloud and data-platform tools such as AWS, Azure, and Snowflake, so a core of SQL, Python, and a BI tool plus some cloud exposure is common at the top end of this sample.

### Most in-demand skills

SQL, Excel, Python, Tableau, and Power BI are the five most requested skills. SQL leads with 92,628 postings, and Excel remains second, which shows that traditional spreadsheet skills are still expected alongside programming and visualization tools.

### Skills associated with higher salaries

The skills with the highest average salaries (SVN, Solidity, Couchbase, DataRobot, and Go) are specialized and rarely requested. Because this query has no minimum posting count, these averages are likely based on very few postings and are best read as a starting point rather than a recommendation.

### Demand and salary

Once a minimum demand threshold is applied, salary differences narrow considerably. Python, Tableau, and R are the most requested skills, at averages of about $99,000 to $101,000. Snowflake, Azure, and AWS offer a strong balance of higher salaries (about $108,000 to $113,000) and solid demand, while Go pays the most but is requested far less often.

---

## Limitations

This analysis describes patterns within the available job-posting dataset and should not be interpreted as a complete representation of the entire data analyst job market.

The results are also based on job postings with available salary information where specified, meaning they may not represent postings where salaries were not disclosed.

* **Outliers:** Average salary is sensitive to extreme values, and the $650,000 Mantys posting was not removed in the first analysis.
* **Inner join in Query 2:** Top-paying postings with no linked skills are excluded, so only eight of the top ten postings appear in that analysis.
* **Remote definition:** A location of `Anywhere` does not always mean fully remote. Two of the top postings mention "Hybrid" in their titles.
* **Small samples:** Query 4 has no minimum number of postings, and Query 5 only requires 11, so some averages rest on few observations.
* **Result cutoff in Query 5:** Ranking by salary and returning 25 rows means widely requested skills with slightly lower average salaries may fall outside the results.
* **Salary and skills are associations:** The analysis does not show that a skill causes a higher salary.

---

## Project Structure

```text
data-analyst-job-market/
│
├── project_sql/
│   ├── 1_top_paying_jobs.sql
│   ├── 2_top_paying_job_skills.sql
│   ├── 3_top_demanded_skills.sql
│   ├── 4_top_paying_skills.sql
│   └── 5_optimal_skills.sql
│
├── assets/
│   ├── Query 1.png
│   ├── Query 2.png
│   ├── Query 3.png
│   ├── Query 4.png
│   └── Query 5.png
│
└── README.md
```

---

## Data Source & Course

This project uses the job-posting dataset and project framework from Luke Barousse's SQL for Data Analytics course.

**Course:** [Luke Barousse — SQL for Data Analytics](https://www.youtube.com/watch?v=MOzEvNYvbik)

The project was completed independently as part of my data analytics learning. I rebuilt the queries while working through the course and adapted parts of the analysis based on my own reasoning and questions.

---

## Future Improvements

* Use median salary (for example with `PERCENTILE_CONT`) alongside the average, to reduce the effect of outliers such as the $650,000 posting.
* Add a minimum posting count to the skills-and-salary analysis so that niche skills with only a few postings do not dominate the results.
* Replace the inner join in the top-paying skills query with a `LEFT JOIN` so that top-paying postings without listed skills are still shown.
* Visualize the demand-versus-salary results in a chart (for example a scatter plot) and extend the analysis to other roles, such as data scientist or data engineer.
