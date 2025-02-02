-- Data Preprocessing

-- Missing Value Checking

SELECT * FROM ds_salaries
	WHERE work_year is NULL
	OR experience_type is NULL 
	OR employment_type is NULL
	OR job_title is NULL
	OR salary is NULL
	OR salary_currency is NULL
	OR employee_residence is NULL
	OR remote_residence is NULL
	OR company_location is NULL
	OR company_size is NULL;
 
-- Delete Duplicate Data

WITH CTE AS (
	SELECT *, ROW_NUMBER () OVER(
	PARTITION BY work_year,
		     experience_level,
		     employment_type,
		     job_title,
		     salary,
		     salary_currency,
		     salary_in_usd,
		     employee_residence,
		     remote_ratio,
		     company_location,
		     company_size ORDER BY id) AS RowNum 
	FROM ds_salaries)
DELETE FROM CTE WHERE RowNum > 1;	

--Business Questions
-- 1. How have average salaries changed over the years?

SELECT work_year, ROUND(
	AVG(salary_in_usd),2)
	AS avg_salary
FROM ds_salaries
GROUP BY work_year
ORDER BY work_year;

-- 2. Which job positions have the highest average salaries?

SELECT TOP 10 job_title,
	ROUND(AVG(salary_in_usg),2)
	AS avg_salary,
	COUNT(*) AS num_employees
FROM ds_salaries	
GROUP BY job_title
ORDER BY avg_salary DESC;

-- 3. How does salary vary by experience level?

SELECT experience_level,
	ROUND(AVG (salary_in_usd),2)
	AS avg_salary
FROM ds_salaries
GROUP BY experience_level
ORDER BY avg_salary DESC;

-- 4. How do salaries differ by company location?

SELECT company_location, 
	ROUND(AVG(salary_in_usd,2)
	AS avg_salary
FROM ds_salaries
GROUP BY company_location
ORDER BY avg_salary DESC;

-- 5. How do remote jobs compare to on-site jobs in terms of salary?

SELECT 
      CASE
	  WHEN remote_ratio = 0 THEN 'On-Site'
	  WHEN remote_ratio = 50 THEN 'Hybrid'
	  WHEN remote_ratio = 100 THEN 'Remote'
      END AS work_type,
      ROUND(AVG(salary_in_usd),2) AS avg_salary
GROUP BY 
      CASE
	  WHEN remote_ratio = 0 THEN 'On-Site'
	  WHEN remote_ratio = 50 THEN 'Hybrid'
	  WHEN remote_ratio = 100 THEN 'Remote'
      END
ORDER BY avg_salary DESC;

