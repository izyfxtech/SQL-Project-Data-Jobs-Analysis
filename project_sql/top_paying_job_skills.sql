/*
Question: What skills are required for the top-paying data analyst jobs?
- Use the top 10 highest-paying Data Analyst jobs from first query
- Add the specific skills required for these roles
- Why? It provides a detailed look at which high-paying jobs demand certain skills, 
    helping job seekers understand which skills to develop that align with top salaries
*/

/*
Solution:
CTE of the top 10 highest paying jobs
JOINED with the skills_job_dim table and then the skills_dim table
Formatted the skills onto one row via STRING_AGG()
*/
WITH top_paying_jobs AS(
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
    job_location ILIKE 'Anywhere' AND
    job_title_short = 'Data Analyst' AND
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