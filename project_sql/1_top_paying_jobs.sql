/*
Question: What are the top-paying data analyst jobs?
Identify the top 10 highest-paying Data Analyst roles that are available remotely.
Focuses on job postings with specified salaries (remove nulls).
Why? Highlight the top-paying opportunities for Data Analysts, offering insights into employment options and location flexibility.
*/


-- Top paying remote Data Analyst jobs
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


-- Top paying Data Analyst roles in Nigeria.
-- PS: There are too few rows where salary_year_avg is not null so I will not be using it.

/*SELECT
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
    job_title_short ILIKE '%Data Analyst%'
    AND
    job_location ILIKE '%Nigeria%'
    AND
    salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC
LIMIT 10;
*/