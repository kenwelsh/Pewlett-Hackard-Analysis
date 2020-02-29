# Pewlett-Hackard-Analysis


## Challenge

### Project Summary
Pewlett Hackard is analyzing the potential number of employees that will be retiring in the next few years.  Findings:
+ Potential retiring population/turnover hiring activity: 33,118
+ The number of individuals on the target list for a supervisory role:  1,549
+ Title counts for retiring population:
##### Retiring Title Count
<table border="1" class="dataframe" style="width:25%">
  <thead>
    <tr align= "center;">
      <th>Title</th>
      <th>Number Retiring</th>
    </tr>
  </thead>
  <tbody>
    <tr align="right">
      <th> Senior Engineer</th>
      <td> 13,651</td>
    </tr>
    <tr align="right">
      <th> Senior Staff</th>
      <td> 12,872</td>
    </tr>
    <tr align="right">
      <th> Engineer</th>
      <td> 2,711</td>
    </tr>
    <tr align="right">
      <th> Staff</th>
      <td> 2,022</td>
    </tr>
    <tr align="right">
      <th> Technique Leader</th>
      <td> 1,609</td>
    </tr>
    <tr align="right">
      <th> Assistant Engineer</th>
      <td> 251</td>
    </tr>
    <tr align="right">
      <th> Manager</th>
      <td> 2</td>
    </tr>
  </tbody>
</table>



Recommendations for additional analysis to support future planning:
+ A deeper dive into retirement activity by gender at the department and position level to understand impacts on the overall current employee population, and develop a diversity/equity strategy for recruiting.
+ Determine the overall percentage of a department and a position potentially retiring to identify high-risk areas.
+ Analyze the remaining employee population for the total time at PH to identify departments that may have succession or skill/knowledge gap issues once employees retire.


#### Resources:
+ pgAdmin version 4.18
+ PostgreSQL version 11.7

####  Entity Relationship Diagram 
![](https://github.com/kenwelsh/Pewlett-Hackard-Analysis/blob/master/Images/EmployeeDB_ERD.png)


PH provided six .csv files, which can be found in the Data folder, to build the database to support the retirement analysis.  Files:
+ departments.csv
+ dept_emp.csv
+ dept_manager.csv
+ employees.csv
+ salaries.csv
+ titles.csv


Department Employee, Department Manager, and Titles have an auto-incrementing id added during table creation as a Primary Key field.  The table structure for these tables allows for duplicates of the key fields as they track the history of changes.  For example, an employee number and department number combination can repeat over the course of a career – i.e., Joe starts in Sales, moves to Marketing, and then returns to Sales.


The Salaries table has a similar table structure, allowing it to track changes over time, but analyzing the data showed that Employee Number only occurs once in the file, allowing it to be the primary key.  The salary data provided is the most recent salary information for an employee.  Adding the full salary history in the future will require an update to the primary key for this table.  


#### Project Requests and PostgreSQL

The project scope includes three deliverables:
1. The full list of potential retiring employees with current title and salary
  + Requested columns:
    + Employee number
    + First name
    + Last name
    + Title
    + From date
    + Salary
2.	A summary file showing the total count by current employee title for the retiring employees (sorted descending)
3.	A list of current employees that are potential targets for a supervisory role.  The criteria for inclusion in the list is a birth date in 1965.
  + Requested columns:
    + Employee number
    + First name
    + Last name
    + Title
    + From date
    + To date
    + Birthdate


#### PostgreSQL for table of all retiring employees created in earlier phase of project

Query to create a table of all potential retirees from a prior phase of the project—the select statement for the first deliverable references this table.  The criteria are all current employees hired between 1985 and 1988 and born between 1952 and 1955.
```SQL
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
```

#### First Deliverable

Use the table of current employees that may be retiring and join on Title and Salaries to pull current title and salary.
```SQL
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
```

##### Example of output
![](https://github.com/kenwelsh/Pewlett-Hackard-Analysis/blob/master/Images/retiring_title_sal.png)

##### First deliverable results .csv file
https://github.com/kenwelsh/Pewlett-Hackard-Analysis/blob/master/Data/Challenge_cur_emp_title_sal.csv


#### Second Deliverable

Use the table created for the first deliverable to group on the current title and get a summary count.
```SQL
SELECT ce.title, COUNT(ce.emp_no)
Into title_count
FROM cur_emp_title_sal as ce
GROUP BY ce.title
ORDER BY COUNT(ce.emp_no) DESC;
```

##### Example of output
![](https://github.com/kenwelsh/Pewlett-Hackard-Analysis/blob/master/Images/title_count.png)

##### Second deliverable results .csv file
https://github.com/kenwelsh/Pewlett-Hackard-Analysis/blob/master/Data/Challenge_title_count.csv


#### Third Deliverable

Use the Employee, Employee Department, and Title tables to build a table of current employees born in 1965.
```SQL
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
```

##### Example of output
![](https://github.com/kenwelsh/Pewlett-Hackard-Analysis/blob/master/Images/target_promo.png)

##### Third deliverable results .csv file
https://github.com/kenwelsh/Pewlett-Hackard-Analysis/blob/master/Data/Challenge_future_promo.csv


#### Challenge Notes
+ challenge.sql located in Queries folder
+ Output .csv files located in Data folder.  Each file starts with "Challenge"
+ ERD .png file located in Images folder
