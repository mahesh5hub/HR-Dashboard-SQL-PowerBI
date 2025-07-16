# HR-Dashboard-SQL-PowerBI<img width="1364" height="785" alt="HR Dashboard Report" src="https://github.com/user-attachments/assets/f1dd9e0d-561b-4d90-a1c5-7ca58bba255d" />

## Project Overview

**Project Title** : HR Employee Distribution Analysis

**Databases** : `projects`

## Data Used

**Data** - HR Data with over 22000 rows from the year 2000 to 2020.

**Data Cleaning & Analysis** - MySQL Workbench

**Data Visualization** - PowerBI

## Data Cleaning
```sql
create database projects;
use projects;
SELECT * FROM hr; 

alter table hr
change column ï»¿id emp_id varchar(20)null;

describe hr;

select birthdate from hr ;

set sql_safe_updates = 0 ;
UPDATE hr 
SET 
    birthdate = CASE
        WHEN
            birthdate LIKE '%/%'
        THEN
            DATE_FORMAT(STR_TO_DATE(birthdate, '%m/%d/%Y'),
                    '%Y-%m-%d')
        WHEN
            birthdate LIKE '%-%'
        THEN
            DATE_FORMAT(STR_TO_DATE(birthdate, '%m-%d-%Y'),
                    '%Y-%m-%d')
        ELSE NULL
    END; 
  
alter table hr 
modify column termdate date;

select termdate from hr;

update hr
set termdate = date(str_to_date(termdate,'%Y-%m-%d %H:%i:%s UTC'))
when termdate like '%-%'THEN DATE_FORMAT(STR_TO_DATE(termdate,' '), '%Y-%m-%d') ;

UPDATE hr 
SET termdate = '0000-00-00'
WHERE termdate = '';


alter table hr
modify column hire_date date;
  
 alter table hr 
 add column age int;
 
UPDATE hr 
SET 
 age = TIMESTAMPDIFF(YEAR,
        birthdate,
        CURDATE());

 describe hr;
 select birthdate,age from hr;
 
SELECT MIN(age) AS youngest, MAX(age) AS oldest
FROM hr

SELECT COUNT(*)
FROM hr
WHERE age < 18;
```
 
## Questions
1. **What is the gender breakdown of employees in the company?**
 ```sql 
SELECT 
    gender, COUNT(*) AS count
FROM
    hr
WHERE
    age >= 18 AND termdate = '0000-00-00'
GROUP BY gender;
```

2.**What is the race/ethnicity breakdown of employees in the company?**
```sql
SELECT 
    race, COUNT(*) AS count
FROM
    hr
WHERE
    age >= 18 AND termdate = '0000-00-00'
GROUP BY race
ORDER BY COUNT(*) DESC;
```
3.**What is the age distribution of employees in the company?**
```sql
SELECT 
    CASE
        WHEN age >= 18 AND age <= 24 THEN '18-24'
        WHEN age >= 25 AND age <= 34 THEN '25-34'
        WHEN age >= 35 AND age <= 44 THEN '35-44'
        WHEN age >= 45 AND age <= 54 THEN '45-54'
        WHEN age >= 55 AND age <= 64 THEN '55-64'
        ELSE '65+'
    END AS age_group,
    COUNT(*) AS count
FROM
    hr
WHERE
    age >= 18 AND termdate = '0000-00-00'
GROUP BY age_group
ORDER BY age_group;

```

4.**How many employees work at headquarters versus remote locations?**
```sql
SELECT 
    location, COUNT(*) AS count
FROM
    hr
WHERE
    age >= 18 AND termdate = '0000-00-00'
GROUP BY location;
```
5.**What is the average length of employment for employees who have been terminated?**
```sql
SELECT 
    ROUND(AVG(DATEDIFF(termdate, hire_date)) / 365,
            0) AS avg_len_employment
FROM
    hr
WHERE
    termdate <= CURDATE()
        AND termdate <> '0000-00-00'
        AND age >= 18;
```
6.**How does the gender distribution vary across departments and job titles?**
```sql
SELECT 
    department, gender, COUNT(*) AS gender_dis
FROM
    hr
WHERE
    age >= 18 AND termdate = '0000-00-00'
GROUP BY department , gender
ORDER BY department;
```
7.**What is the distribution of job titles across the company?**
```sql
SELECT 
    jobtitle, COUNT(*) AS job_title_count
FROM
    hr
WHERE
    age >= 18 AND termdate = '0000-00-00'
GROUP BY jobtitle;
```
8.**Which department has the highest turnover rate?**
```sql
SELECT 
    department,
    total_count,
    terminated_count,
    terminated_count / total_count AS termination_rate
FROM
    (SELECT 
        department,
            COUNT(*) AS total_count,
            SUM(CASE
                WHEN
                    termdate <> '0000-00-00'
                        AND termdate <= CURDATE()
                THEN
                    1
                ELSE 0
            END) AS terminated_count
    FROM
        hr
    WHERE
        age >= 18
    GROUP BY department) AS subquery
ORDER BY termination_rate DESC;

```
9.**What is the distribution of employees across locations by state?**
```sql
SELECT 
    location_state, COUNT(*) AS count
FROM
    hr
WHERE
    age >= 18 AND termdate = '0000-00-00'
GROUP BY location_state
ORDER BY count DESC;
```
10.**How has the company's employee count changed over time based on hire and term dates?**
```sql
SELECT 
    year,
    hires,
    terminations,
    hires - terminations AS net_change,
    ROUND((hires - terminations) / hires * 100, 2) AS net_change_percent
FROM
    (SELECT 
        YEAR(hire_date) AS year,
            COUNT(*) AS hires,
            SUM(CASE
                WHEN
                    termdate <> '0000-00-00'
                        AND termdate <= CURDATE()
                THEN
                    1
                ELSE 0
            END) AS terminations
    FROM
        hr
    WHERE
        age >= 18
    GROUP BY YEAR(hire_date)) AS sub_query
ORDER BY year ASC;   
```
11.**What is the tenure distribution for each department?**
```sql
SELECT 
    department,
    ROUND(AVG(DATEDIFF(termdate, hire_date) / 365),
            0) AS avg_tenure
FROM
    hr
WHERE
    termdate <= CURDATE()
        AND termdate <> '0000-00-00'
        AND age >= 18
GROUP BY department;
```

## Summary of Findings

- There are more male employees
  
- White race is the most dominant while Native Hawaiian and American Indian are the least dominant.
- The youngest employee is 20 years old and the oldest is 57 years old
- 5 age groups were created (18-24, 25-34, 35-44, 45-54, 55-64). A large number of employees were between 25-34 followed by 35-44 while the smallest group was 55-64.
- A large number of employees work at the headquarters versus remotely.
- The average length of employment for terminated employees is around 7 years.
- The gender distribution across departments is fairly balanced but there are generally more male than female employees.
- The Marketing department has the highest turnover rate followed by Training. The least turn over rate are in the Research and development, Support and Legal departments.
- A large number of employees come from the state of Ohio.
- The net change in employees has increased over the years.
- The average tenure for each department is about 8 years with Legal and Auditing having the highest and Services, Sales and Marketing having the lowest.

## Limitations

- Some records had negative ages and these were excluded during querying(967 records). Ages used were 18 years and above.

- Some termdates were far into the future and were not included in the analysis(1599 records). The only term dates used were those less than or equal to the current date.
