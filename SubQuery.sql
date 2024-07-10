-- Create the department table
drop table department
CREATE TABLE department (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(50) NOT NULL
);

-- Create the employee table
drop table employee
CREATE TABLE employee (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(100) NOT NULL,
    department_id INT,
    salary DECIMAL(10, 2),
    FOREIGN KEY (department_id) REFERENCES department(department_id)
);


-- Insert records into the department table
INSERT INTO department (department_id, department_name) VALUES
(1, 'HR'),
(2, 'Finance'),
(3, 'Engineering'),
(4, 'Marketing'),
(5, 'Sales');

-- Insert records into the employee table
INSERT INTO employee (emp_id, emp_name, department_id, salary) VALUES
(1, 'Alice', 1, 60000),
(2, 'Bob', 2, 70000),
(3, 'Charlie', 3, 80000),
(4, 'David', 4, 55000),
(5, 'Eve', 5, 50000),
(6, 'Frank', 1, 62000),
(7, 'Grace', 2, 71000),
(8, 'Hank', 3, 85000),
(9, 'Ivy', 4, 56000),
(10, 'Jack', 5, 52000),
(11, 'Karen', 1, 64000),
(12, 'Leo', 2, 72000),
(13, 'Mona', 3, 88000),
(14, 'Nate', 4, 57000),
(15, 'Olivia', 5, 53000),
(16, 'Paul', 1, 66000),
(17, 'Quinn', 2, 73000),
(18, 'Rita', 3, 90000),
(19, 'Sam', 4, 58000),
(20, 'Tina', 5, 54000),
(21, 'Uma', 1, 68000),
(22, 'Victor', 2, 74000),
(23, 'Wendy', 3, 92000),
(24, 'Xander', 4, 59000),
(25, 'Yara', 5, 55000);

select * from employee
select * from department

with cte as (
select a.*,b.department_name, dense_rank() over (partition by b.department_name order by a.salary desc) rnk
from employee a join department b 
on a.department_id=b.department_id)
select * from cte 
where rnk = 1

-- FIND THE EMPLOYEE WHO'S SALARY IS MORE THAN THE AVG SALARY EARN BY EMPLOYEE?
select 
	emp_name,
	department_name,
	salary 
from (
		select a.*,
			   b.department_name 
		from employee a 
		join department b 
		on a.department_id=b.department_id) a
where salary >= (select avg(salary) avg_salary from employee)
order by 2
-------------------------------------------------------------------------------
-- SCALLAR SUB-QUERY
	--IT ALWAYS RETURNS 1 ROW AND 1 COLUMN.
-- FIND THE EMPLOYEE WHO'S SALARY IS MORE THAN THE AVG SALARY EARN BY EMPLOYEE?
-- Subquery in where clause.
select * from employee
where salary >= (select avg(salary) avg_salary from employee)

-- Subquery in JOINS
select * from employee a
join (select avg(salary) avg_salary from employee) x
on a.salary>x.avg_salary						-- I am getting one additional column

-- MULTIPLE ROW SUBQUERY
-- Subquery which returns Multiple column and Multiple row
-- Subquery which returns only one column and Multiple row

-- FIND THE EMPLOYEES WHO EARN THE HIGHEST SALARY IN EACH DEPARTMENT?
select * from employee
select * from department

SELECT e.emp_id, e.emp_name, e.department_id, e.salary
FROM employee e
WHERE e.salary = (
    SELECT MAX(salary)
    FROM employee
    where  department_id=e.department_id
);
----------------------------------------------------------------
-- Single column and multiple row subquery
-- Find dept who do not have any employees
select * from employee
select * from department 

select * from department
where department_name not in (select distinct(department_name) from department)

---------------------------------------------------------------------------------
-- CORRELATED SUBQUERY
-- A SUBQUERY WHICH IS RELATED TO THE OUTER QUERY.
-- PROCESSING OF SUBQUERY IS DEPENDS THE VALUES THAT ARE RETURN FROM THE OUTER QUERY.
When its comes to correlated subquery is slightly differente.

-- Find the employees in each department who earn more than the avg salary in each department.
select * from employee
select * from department 

select department_id,avg(salary) avg_salary from employee group by department_id

select * 
from employee e
join (select department_id,avg(salary) avg_salary 
				 from employee group by department_id ) a
on a.department_id=e.department_id
where e.salary>a.avg_salary
----------------------------------------------------------------------------------------------------------------------------
-- Create the sales table
drop table sales
CREATE TABLE sales (
    store_id INT,
    store_name VARCHAR(50),
    product_name VARCHAR(50),
    quantity INT,
    price DECIMAL(10, 2)
);

-- Insert sample data into the sales table
INSERT INTO sales (store_id, store_name, product_name, quantity, price) VALUES
(1, 'Store A', 'Product 1', 10, 20.00),
(1, 'Store A', 'Product 2', 5, 30.00),
(2, 'Store B', 'Product 1', 8, 22.00),
(2, 'Store B', 'Product 3', 3, 25.00),
(3, 'Store C', 'Product 2', 7, 28.00),
(3, 'Store C', 'Product 3', 9, 26.00);

-- QUE. FIND THE STORES WHO'S SALES WHERE BETTER THAN THE AVG SALES ACCROSS ALL STORES.
select 
	store_id,
	store_name,
	product_name,
	quantity,
	price,
	quantity*price sales
from sales

select *,avg(price) avg_sales from sales s
join (select store_name, sum(price*quantity) total_sales from sales group by store_name) x
on s.store_name = x.store_name
where s.price*s.quantity > x.total_sales
------------------------------------------------------------------------------------------------------------------
--WHICH EMPLOYEE TAKING SALARY MORE THAN OVERALL AVG_SALARY
select *
from employee
where salary > (select avg(salary) avg_salary from employee) 
------------------------------------------------------------------------------------------------------------------
-- Find the names of employees who have a higher salary than the highest salary in the 'HR' department.
select *
from employee  
where salary > (select max(salary) from employee 
				 where department_id = (select department_id from department 
										where department_name='hr'))
-----------------------------------------------------------------------------------------------------------------
-- Find the names of employees whose salary is higher than the average salary of their respective departments.
SELECT EmployeeName 
FROM Employees e
WHERE Salary > (SELECT AVG(Salary) 
                FROM Employees 
                WHERE DepartmentID = e.DepartmentID);
-----------------------------------------------------------------------------------------------------------------
-- Find the departments that have more than 1 employee.
SELECT DepartmentName 
FROM Departments 
WHERE DepartmentID IN (SELECT DepartmentID 
                       FROM Employees 
                       GROUP BY DepartmentID 
                       HAVING COUNT(*) > 1);
-----------------------------------------------------------------------------------------------------------------
-- Find employees who have the highest salary in their department.
SELECT EmployeeName 
FROM Employees e 
WHERE Salary = (SELECT MAX(Salary) 
                FROM Employees 
                WHERE DepartmentID = e.DepartmentID);
-----------------------------------------------------------------------------------------------------------------
-- Find the names of employees who earn more than the average salary across all 
-- departments and are in departments with fewer than 3 employees.
SELECT EmployeeName 
FROM Employees 
WHERE Salary > (SELECT AVG(Salary) FROM Employees)
  AND DepartmentID IN (SELECT DepartmentID 
                       FROM Employees 
                       GROUP BY DepartmentID 
                       HAVING COUNT(*) < 3);
-----------------------------------------------------------------------------------------------------------------
-- Find the employees who earn more than the average salary of employees in each department 
-- and their salaries are also above the overall average salary.
SELECT EmployeeName 
FROM Employees e
WHERE Salary > (SELECT AVG(Salary) 
                FROM Employees 
                WHERE DepartmentID = e.DepartmentID)
  AND Salary > (SELECT AVG(Salary) 
                FROM Employees);
-----------------------------------------------------------------------------------------------------------------
-- Find the employees who have the second highest salary in their department.
SELECT EmployeeName 
FROM Employees e
WHERE Salary = (SELECT MAX(Salary) 
                FROM Employees 
                WHERE DepartmentID = e.DepartmentID 
                  AND Salary < (SELECT MAX(Salary) 
                                FROM Employees 
                                WHERE DepartmentID = e.DepartmentID));
=-----------------------------------------------------------------------------------------------------------------

-- Find the students who have scored more than 50 in SAS.
drop table scores
CREATE TABLE Scores (
    Application VARCHAR(10),
    Stu_Name VARCHAR(20),
    Score INT
);

INSERT INTO Scores (Application, Stu_Name, Score) VALUES
('SAS', 'ABHISHEK', 74),
('SAS', 'AHUTI', 53),
('SAS', 'AMLAN', 23),
('SAS', 'BARNALI', 47),
('SAS', 'KOMAL', 60),
('PYTHON', 'ABHISHEK', 79),
('PYTHON', 'AHUTI', 21),
('PYTHON', 'AMLAN', 83),
('PYTHON', 'BARNALI', 16),
('PYTHON', 'KOMAL', 76),
('SQL', 'ABHISHEK', 31),
('SQL', 'AHUTI', 60),
('SQL', 'AMLAN', 14),
('SQL', 'BARNALI', 100),
('SQL','KOMAL',99)

select * into STU_APP_SCORE from scores;

-- Find the students who have scored more than 50 in SAS.
select 
	stu_name,
	application,
	score
from scores
where application='sas' and score > 50;

-- Find the maximum score for each application.
select * from (select 
				application,
				score,
				DENSE_RANK() over (partition by application order by score desc) highest_score
				from scores) a
where highest_score <= 1

select
	*,
	max(score) over (partition by application order by score desc) Max_Score
from scores

select 
	*,
	FIRST_VALUE(score) over(partition by application order by score desc) Highest_score
from scores

with cte as (select *, dense_rank() over(partition by application order by score) ScoreRanks from scores)
select * from cte 
where ScoreRanks <= 1

--Intermediate
	--Find the names of students who have scored above average in Python.
	select 
		a.stu_name,
		a.application,
		a.score
	from scores as a
	join 
	(select
		application,
		avg(score) python_avg 
	from scores 
	where application = 'python' 
	group by Application) b
	on a.Application=b.Application
	where a.Score>b.python_avg

select 
	stu_name,Score
from scores
where Application='python' and
score > (select avg(score) from scores where Application='python')


-- Find the students who have scored higher in SQL than the average score of SAS
select 
	stu_name,score
from scores 
where Application = 'sql' 
and score > (select avg(score) from scores where Application='sas')

-- Find the student who has the highest total score across all applications.
select stu_name ,score
from scores 
order by score desc

SELECT stu_name
FROM Scores
GROUP BY stu_name
ORDER BY SUM(score) DESC
-- Find the students whose scores in Python are higher than the maximum score in SAS.
select 
	stu_name
from scores
where Application='python'
and score > (select max(score) from scores where Application = 'sas' )
group by stu_name



