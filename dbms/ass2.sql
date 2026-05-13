CREATE DATABASE company_db;
USE company_db;

CREATE TABLE company (
    cmp_id INT PRIMARY KEY,
    company_name VARCHAR(100),
    city VARCHAR(50)
);

CREATE TABLE employee (
    emp_id INT PRIMARY KEY,
    employee_name VARCHAR(50),
    street VARCHAR(100),
    city VARCHAR(50),
    email_id VARCHAR(100),
    comp_id INT,
    salary DECIMAL(10,2),

    FOREIGN KEY (comp_id)
    REFERENCES company(cmp_id)
);

CREATE TABLE manages (
    emp_id INT,
    mgr_id INT,

    PRIMARY KEY (emp_id, mgr_id),

    FOREIGN KEY (emp_id)
    REFERENCES employee(emp_id),

    FOREIGN KEY (mgr_id)
    REFERENCES employee(emp_id)
);


INSERT INTO company VALUES
(1, 'First Bank Corporation', 'Mumbai'),
(2, 'Yes Bank Corporation', 'Delhi'),
(3, 'Small Bank Corporation', 'Kolkata'),
(4, 'ABC Technologies', 'Varanasi');


INSERT INTO employee VALUES
(101, 'Pankaj', 'MG Road', 'Varanasi', 'pankaj@gmail.com', 1, 60000),
(102, 'Priya', 'Park Street', 'Mumbai', 'priya@gmail.com', 2, 45000),
(103, 'Smith Jones', 'Civil Lines', 'Varanasi', 'smith@gmail.com', 1, 80000),
(104, 'Anita', 'Lake Road', 'Kolkata', 'anita@gmail.com', 3, 30000),
(105, 'Preeti', 'Ring Road', 'Delhi', 'preeti@gmail.com', 4, 55000),
(106, 'Ramesh', 'Station Road', 'Mumbai', 'ramesh@gmail.com', 1, 25000),
(107, 'Pooja', 'GT Road', 'Varanasi', 'pooja@gmail.com', 2, 70000);


INSERT INTO manages VALUES
(101, 103),
(102, 103),
(104, 103),
(105, 107),
(106, 103);


-- Q1
-- Find names and cities of residence of employees
-- working for First Bank Corporation.

SELECT e.employee_name, e.city
FROM employee e
JOIN company c
ON e.comp_id = c.cmp_id
WHERE c.company_name = 'First Bank Corporation';


-- Q2
-- Find names of employees working for First Bank
-- Corporation or Yes Bank Corporation.

SELECT e.employee_name
FROM employee e
JOIN company c
ON e.comp_id = c.cmp_id
WHERE c.company_name IN
('First Bank Corporation', 'Yes Bank Corporation');


-- Q3
-- Find employee names and company names whose
-- salary is between 20000 and 50000.

SELECT e.employee_name, c.company_name
FROM employee e
JOIN company c
ON e.comp_id = c.cmp_id
WHERE e.salary BETWEEN 20000 AND 50000;


-- Q4
-- Find names, street and city of employees working
-- for First Bank Corporation earning more than 10000.

SELECT e.employee_name, e.street, e.city
FROM employee e
JOIN company c
ON e.comp_id = c.cmp_id
WHERE c.company_name = 'First Bank Corporation'
AND e.salary > 10000;


-- Q5
-- Find employees who do not work for
-- First Bank Corporation.

SELECT employee_name
FROM employee
WHERE comp_id NOT IN (
    SELECT cmp_id
    FROM company
    WHERE company_name = 'First Bank Corporation'
);


-- Q6
-- Find employees working under manager Smith Jones.

SELECT e.employee_name
FROM employee e
JOIN manages m
ON e.emp_id = m.emp_id
JOIN employee mgr
ON m.mgr_id = mgr.emp_id
WHERE mgr.employee_name = 'Smith Jones';


-- Q7
-- List manager names who live in Varanasi.

SELECT DISTINCT mgr.employee_name
FROM employee mgr
JOIN manages m
ON mgr.emp_id = m.mgr_id
WHERE mgr.city = 'Varanasi';


-- Q8
-- Find manager name, city and salary whose
-- name starts with P.

SELECT DISTINCT mgr.employee_name,
mgr.city,
mgr.salary
FROM employee mgr
JOIN manages m
ON mgr.emp_id = m.mgr_id
WHERE mgr.employee_name LIKE 'P%';


-- Q9
-- Find employee names whose company name's
-- 3rd last character is 'i'.

SELECT e.employee_name
FROM employee e
JOIN company c
ON e.comp_id = c.cmp_id
WHERE c.company_name LIKE '%i__';


-- Q10
-- Find employees living in same city as
-- their company.

SELECT e.employee_name
FROM employee e
JOIN company c
ON e.comp_id = c.cmp_id
WHERE e.city = c.city;


-- Q11
-- Find employees living in same city and street
-- as their managers.

SELECT e.employee_name
FROM employee e
JOIN manages m
ON e.emp_id = m.emp_id
JOIN employee mgr
ON m.mgr_id = mgr.emp_id
WHERE e.city = mgr.city
AND e.street = mgr.street;


-- Q12
-- Find employees earning more than each employee
-- of Small Bank Corporation.

SELECT employee_name
FROM employee
WHERE salary > ALL (
    SELECT salary
    FROM employee e
    JOIN company c
    ON e.comp_id = c.cmp_id
    WHERE c.company_name = 'Small Bank Corporation'
);


-- Q13
-- Find employees earning more than average salary
-- of their company.

SELECT e.employee_name
FROM employee e
WHERE e.salary > (
    SELECT AVG(e2.salary)
    FROM employee e2
    WHERE e.comp_id = e2.comp_id
);


-- Q14
-- Find company having maximum employees.

SELECT c.company_name
FROM company c
JOIN employee e
ON c.cmp_id = e.comp_id
GROUP BY c.company_name
HAVING COUNT(*) = (
    SELECT MAX(emp_count)
    FROM (
        SELECT COUNT(*) AS emp_count
        FROM employee
        GROUP BY comp_id
    ) AS temp
);


-- Q15
-- Find company having smallest payroll.

SELECT c.company_name
FROM company c
JOIN employee e
ON c.cmp_id = e.comp_id
GROUP BY c.company_name
HAVING SUM(e.salary) = (
    SELECT MIN(total_payroll)
    FROM (
        SELECT SUM(salary) AS total_payroll
        FROM employee
        GROUP BY comp_id
    ) AS temp
);


-- Q16
-- Find companies whose average salary is higher
-- than average salary of First Bank Corporation.

SELECT c.company_name
FROM company c
JOIN employee e
ON c.cmp_id = e.comp_id
GROUP BY c.company_name
HAVING AVG(e.salary) > (
    SELECT AVG(e2.salary)
    FROM employee e2
    JOIN company c2
    ON e2.comp_id = c2.cmp_id
    WHERE c2.company_name = 'First Bank Corporation'
);


-- Q17
-- Modify database so that Jones now lives
-- in New Delhi.

UPDATE employee
SET city = 'New Delhi'
WHERE employee_name = 'Smith Jones';


-- Q18
-- Give all employees of First Bank Corporation
-- a 10 percent salary raise.

UPDATE employee
SET salary = salary + (salary * 0.10)
WHERE comp_id = (
    SELECT cmp_id
    FROM company
    WHERE company_name = 'First Bank Corporation'
);


-- Q19
-- Delete Small Bank Corporation and its employees.

DELETE FROM employee
WHERE comp_id = (
    SELECT cmp_id
    FROM company
    WHERE company_name = 'Small Bank Corporation'
);

DELETE FROM company
WHERE company_name = 'Small Bank Corporation';