create database projects;
use projects;
select * from hr; 

alter table hr
change column ï»¿id emp_id varchar(20)null;

describe hr;

select birthdate from hr ;

set sql_safe_updates = 0 ;
update hr 
set birthdate = case 
  when birthdate like '%/%'then date_format(str_to_date(birthdate,'%m/%d/%Y'),'%Y-%m-%d')
  when birthdate like '%-%'THEN DATE_FORMAT(STR_TO_DATE(birthdate, '%m-%d-%Y'), '%Y-%m-%d')
  else null
  end; 
  
alter table hr 
modify column termdate date;

select termdate from hr;

update hr
set termdate = date(str_to_date(termdate,'%Y-%m-%d %H:%i:%s UTC'))
when termdate like '%-%'THEN DATE_FORMAT(STR_TO_DATE(termdate, ' '), '%Y-%m-%d') ;

UPDATE hr
SET termdate = '0000-00-00'
WHERE termdate = '';


alter table hr
modify column hire_date date;
  
 alter table hr 
 add column age int;
 
 update hr 
 set age = timestampdiff(year,birthdate ,curdate());
 
 describe hr;
 select birthdate,age from hr;
 
 select min(age) as youngest,
 max(age) as oldest
 from hr;
 
 select count(*)from hr 
 where age < 18 ; 
 
 
 

