-- Module 7 Challenge

-- Creating tables for PH-EmployeeDB
CREATE TABLE departments (
     dept_no VARCHAR(4) NOT NULL,
     dept_name VARCHAR(40) NOT NULL,
PRIMARY KEY (dept_no),
UNIQUE (dept_name)
);


CREATE TABLE employees (
	 emp_no INT NOT NULL,
     birth_date DATE NOT NULL,
     first_name VARCHAR NOT NULL,
     last_name VARCHAR NOT NULL,
     gender VARCHAR NOT NULL,
     hire_date DATE NOT NULL,
PRIMARY KEY (emp_no)
);


-- Uncheck dm_id column in Columns to Import 
-- when importing csv file using pgAdmin GUI
CREATE TABLE dept_manager (
	dm_id Serial Primary Key,
	dept_no VARCHAR(4) NOT NULL,
	emp_no INT NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
FOREIGN KEY (dept_no) REFERENCES departments (dept_no)
);


CREATE TABLE salaries (
	emp_no INT NOT NULL Primary Key,
	salary INT NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
FOREIGN KEY (emp_no) REFERENCES employees (emp_no)
);


-- Uncheck de_id column in Columns to Import 
-- when importing csv file using pgAdmin GUI
CREATE TABLE dept_emp (
	de_id Serial Primary Key,
	emp_no INT NOT NULL,
	dept_no VARCHAR(4) NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
FOREIGN KEY (dept_no) REFERENCES departments (dept_no)
);


-- Uncheck t_id column in Columns to Import 
-- when importing csv file using pgAdmin GUI
CREATE TABLE titles (
	t_id Serial Primary Key,
	emp_no INT NOT NULL,
	title VARCHAR NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
FOREIGN KEY (emp_no) REFERENCES employees (emp_no)
);


-- Challenge Part 1

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

-- 1) Number of [titles] Retiring table (inner join)
-- fields: employee number, first and last name, title, from date, salary

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
-- count: 33118
SELECT COUNT(emp_no)
FROM cur_emp_title_sal;

-- count distinct:  33118
SELECT COUNT(Distinct emp_no)
FROM cur_emp_title_sal;


-- 2) In descending order, list the frequency count of employee
-- titles (i.e., how many employees share the same title?)

-- create a table of counts of titles for potential retiring employees
-- table sums to 33118 total
SELECT ce.title, COUNT(ce.emp_no)
Into title_count
FROM cur_emp_title_sal as ce
GROUP BY ce.title
ORDER BY COUNT(ce.emp_no) DESC;


-- 3) Who’s Ready for a Mentor?  Create a new table that contains 
-- the following information: emp no, first and last name, title, from date
-- and to date.  birth date between 1/1/1965 and 12/31/1965
-- Instructions at beginning of Challenge said to include birth date in table

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
-- count: 1549
SELECT COUNT(emp_no)
FROM future_promo;

-- count distinct: 1549
SELECT COUNT(Distinct emp_no)
FROM future_promo;


-- Part 2
-- write up -  number of individuals retiring, number of individuals being
-- hired, number of individuals available for mentorship role

-- number eligible for retirement
SELECT COUNT(emp_no)
FROM current_emp;


-- Titles potentially retiring/hiring
SELECT * FROM title_count;


-- number of individuals available for mentorship role
SELECT COUNT(emp_no)
FROM future_promo;

