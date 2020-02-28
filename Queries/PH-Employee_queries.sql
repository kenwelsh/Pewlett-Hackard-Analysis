-- drop table example
-- DROP TABLE employees CASCADE;

-- Retirement eligibility
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1955-12-31';

SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1952-12-31';


-- Retirement eligibility
SELECT first_name, last_name
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');


-- Number of employees retiring
SELECT COUNT(first_name)
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');


SELECT first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');


SELECT * FROM retirement_info;


DROP TABLE retirement_info;



-- Create new table for retiring employees
SELECT emp_no, first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');
-- Check the table
SELECT * FROM retirement_info;


-- Joining departments and dept_manager tables
SELECT departments.dept_name,
     dept_manager.emp_no,
     dept_manager.from_date,
     dept_manager.to_date
FROM departments
INNER JOIN dept_manager
ON departments.dept_no = dept_manager.dept_no;



-- Joining retirement_info and dept_emp tables
SELECT retirement_info.emp_no,
	retirement_info.first_name,
	retirement_info.last_name,
	dept_emp.to_date
FROM retirement_info
LEFT JOIN dept_emp
ON retirement_info.emp_no = dept_emp.emp_no;


-- Joining retirement_info and dept_emp tables
SELECT retirement_info.emp_no,
	retirement_info.first_name,
	retirement_info.last_name,
	dept_emp.to_date
FROM retirement_info
LEFT JOIN dept_emp
ON retirement_info.emp_no = dept_emp.emp_no;

-- example using aliases for the table names
SELECT ri.emp_no,
	ri.first_name,
	ri.last_name,
	de.to_date
FROM retirement_info as ri
LEFT JOIN dept_emp as de
ON ri.emp_no = de.emp_no;


SELECT d.dept_name,
     dm.emp_no,
     dm.from_date,
     dm.to_date
FROM departments as d
INNER JOIN dept_manager as dm
ON d.dept_no = dm.dept_no;



SELECT ri.emp_no,
	ri.first_name,
	ri.last_name,
	de.to_date
INTO current_emp
FROM retirement_info as ri
LEFT JOIN dept_emp as de
ON ri.emp_no = de.emp_no
WHERE de.to_date = ('9999-01-01');


-- Employee count by department number
SELECT COUNT(ce.emp_no), de.dept_no
INTO dept_count
FROM current_emp as ce
LEFT JOIN dept_emp as de
ON ce.emp_no = de.emp_no
GROUP BY de.dept_no
ORDER BY de.dept_no;


	
SELECT * FROM salaries
ORDER BY to_date DESC;


SELECT emp_no,
	first_name,
	last_name,
	gender
INTO emp_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

DROP TABLE emp_info;


SELECT e.emp_no,
	e.first_name,
	e.last_name,
	e.gender,
	s.salary,
	de.to_date
INTO emp_info
FROM employees as e
INNER JOIN salaries as s
	ON (e.emp_no = s.emp_no)
INNER JOIN dept_emp as de
	ON (e.emp_no = de.emp_no)
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
     AND (e.hire_date BETWEEN '1985-01-01' AND '1988-12-31')
     AND (de.to_date = '9999-01-01')
ORDER BY e.last_name, e.first_name;


-- List of managers per department
SELECT  dm.dept_no,
        d.dept_name,
        dm.emp_no,
        ce.last_name,
        ce.first_name,
        dm.from_date,
        dm.to_date
-- INTO manager_info
FROM dept_manager AS dm
    INNER JOIN departments AS d
        ON (dm.dept_no = d.dept_no)
    INNER JOIN current_emp AS ce
        ON (dm.emp_no = ce.emp_no);


SELECT ce.emp_no,
	ce.first_name,
	ce.last_name,
	d.dept_name	
-- INTO dept_info
FROM current_emp as ce
INNER JOIN dept_emp AS de
	ON (ce.emp_no = de.emp_no)
INNER JOIN departments AS d
	ON (de.dept_no = d.dept_no);


Select * from current_emp;


SELECT ce.emp_no,
	ce.first_name,
	ce.last_name,
	d.dept_name	
-- INTO dept_info
FROM current_emp as ce
INNER JOIN dept_emp AS de
	ON (ce.emp_no = de.emp_no)
INNER JOIN departments AS d
	ON (de.dept_no = d.dept_no)
Where d.dept_name In ('Sales', 'Development')
ORDER BY d.dept_name, ce.last_name, ce.first_name;	

Select * from departments;


Select * from current_emp;


SELECT ce.emp_no,
	ce.first_name,
	ce.last_name,
	d.dept_name	
-- INTO dept_info
FROM current_emp as ce
INNER JOIN dept_emp AS de
	ON (ce.emp_no = de.emp_no)
INNER JOIN departments AS d
	ON (de.dept_no = d.dept_no)
Where d.dept_name In ('Sales', 'Development')
ORDER BY d.dept_name, ce.last_name, ce.first_name;	

Select * from departments;

SELECT * FROM titles
ORDER BY to_date DESC;

SELECT COUNT(emp_no)
FROM salaries;

SELECT COUNT(Distinct emp_no)
FROM salaries;


ALTER TABLE salaries
  ADD CONSTRAINT salaries_pk 
    PRIMARY KEY (emp_no);


SELECT COUNT(dept_no)
FROM dept_manager;

SELECT COUNT(Distinct dept_no)
FROM dept_manager; 

Select * from dept_manager
Order by (dept_no, emp_no);

ALTER TABLE dept_manager
	ADD COLUMN dm_id SERIAL PRIMARY KEY;
	
	
Select * from dept_manager
Order by (dept_no, emp_no);

ALTER TABLE dept_emp
	ADD COLUMN de_id SERIAL PRIMARY KEY;	

ALTER TABLE titles
	ADD COLUMN t_id SERIAL PRIMARY KEY;



-- Module 7 Challenge

-- Part 1

-- 1) Number of [titles] Retiring table (inner join)
-- fields: employee number, first and last name, title, from date, salary

-- Create a table of all potential retiring employees (done with original analysis)
SELECT e.emp_no,
	e.first_name,
	e.last_name,
	de.to_date
INTO current_emp
FROM employees as e
INNER JOIN dept_emp as de
	ON (e.emp_no = de.emp_no)
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
     AND (e.hire_date BETWEEN '1985-01-01' AND '1988-12-31')
     AND (de.to_date = '9999-01-01')
ORDER BY e.last_name, e.first_name;

-- Create a table of potential retiring employees with current title and salary.
SELECT ce.emp_no,
	ce.first_name,
	ce.last_name,
	ti.title,
	ti.from_date,
	s.salary
INTO cur_emp_title_sal
FROM current_emp as ce
INNER JOIN titles AS ti
	ON (ce.emp_no = ti.emp_no)
INNER JOIN salaries AS s
	ON (ce.emp_no = s.emp_no)
Where ti.to_date = '9999-01-01'
ORDER BY ce.last_name, ce.first_name;

-- check counts for duplicate emp_no
SELECT COUNT(emp_no)
FROM cur_emp_title_sal;
-- count: 33118

SELECT COUNT(Distinct emp_no)
FROM cur_emp_title_sal;
-- count distinct:  33118

-- 2) In descending order, list the frequency count of employee
-- titles (i.e., how many employees share the same title?)

-- create a table of counts of titles for potential retiring employees
SELECT ce.title, COUNT(ce.emp_no)
Into title_count
FROM cur_emp_title_sal as ce
GROUP BY ce.title
ORDER BY COUNT(ce.emp_no) DESC;
-- table sums to 33118

-- 3) Who’s Ready for a Mentor?  Create a new table that contains 
-- the following information: emp no, first and last name, title, from date
-- and to date.  birth date between 1/1/1965 and 12/31/1965

-- create a table of employees that are targets for supervisory role
SELECT e.emp_no,
	e.first_name,
	e.last_name,
	ti.title,
	ti.from_date,
	ti.to_date,
	e.birth_date
INTO future_promo
FROM employees as e
INNER JOIN titles AS ti
	ON (e.emp_no = ti.emp_no)
INNER JOIN dept_emp as de
	ON (e.emp_no = de.emp_no)
WHERE (e.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
     AND (de.to_date = '9999-01-01')
	 AND (ti.to_date = '9999-01-01')
ORDER BY e.last_name, e.first_name;

-- check counts for duplicate emp_no
SELECT COUNT(emp_no)
FROM future_promo;
-- count: 1549

SELECT COUNT(Distinct emp_no)
FROM future_promo;
-- count distinct: 1549

-- Part 2

-- write up -  number of individuals retiring, number of individuals being
-- hired, number of individuals available for mentorship role
-- one recommendation for further analysis on this data set
-- Code for the requested queries, with examples of each output	

-- number eligible for retirement
SELECT COUNT(emp_no)
FROM current_emp;
-- count: 33118

-- Titles potentially retiring/hiring
SELECT * FROM title_count;
-- Senior Engineer: 13651
-- Senior Staff: 12872
-- Engineer: 2711
-- Staff: 2022
-- Technique Leader: 1609
-- Assistant Engineer: 251
-- Manager: 2

-- number of individuals available for mentorship role
SELECT COUNT(emp_no)
FROM future_promo;
-- count: 1549


-- drop table example
-- DROP TABLE titles2 CASCADE;

