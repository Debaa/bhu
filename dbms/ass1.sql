CREATE DATABASE employee_db;

USE employee_db;

CREATE TABLE Employee (
    Employee_ID INT PRIMARY KEY,
    Name VARCHAR(50),
    Age INT,
    Salary DECIMAL(10,2),
    City VARCHAR(50),
    Country VARCHAR(50),
    Email_id VARCHAR(100)
);


INSERT INTO Employee VALUES
(101, 'Pankaj', 45, 60000, 'Varanasi', 'India', 'pankaj@gmail.com'),
(102, 'Priya', 32, 45000, 'Mumbai', 'India', 'priya@yahoo.com'),
(103, 'Amit', 55, 70000, 'Varanasi', 'Germany', 'amit@gmail.com'),
(104, 'Sneha', 29, 25000, 'Lucknow', 'France', 'sneha@gmail.com'),
(105, 'Ritika', 40, 52000, 'Kolkata', 'Japan', 'ritika@hotmail.com'),
(106, 'Pooja', 51, 80000, 'Varanasi', 'India', 'pooja@gmail.com'),
(107, 'Anita', 38, 30000, 'Mumbai', 'China', 'anita@yahoo.com'),
(108, 'Ramesha', 47, 48000, 'Delhi', 'South Korea', 'ramesha@gmail.com'),
(109, 'Preeti', 35, 55000, 'Lucknow', 'North Korea', 'preeti@gmail.com'),
(110, 'Sonia', 28, 22000, 'Patna', 'India', 'sonia@gmail.com');


-- Q1
-- List Employee_ID, Name, Age and Salary
-- of all employees.

SELECT Employee_ID, Name, Age, Salary
FROM Employee;


-- Q2
-- List Name, Age and Salary of employees
-- who live in Varanasi.

SELECT Name, Age, Salary
FROM Employee
WHERE City = 'Varanasi';


-- Q3
-- List Name, Age and Salary of employees
-- who do not live in Kolkata.

SELECT Name, Age, Salary
FROM Employee
WHERE City <> 'Kolkata';


-- Q4
-- List Name and Salary of employees who
-- live in Mumbai in sorted order of salary.

SELECT Name, Salary
FROM Employee
WHERE City = 'Mumbai'
ORDER BY Salary;


-- Q5
-- List Employee_ID, Name, Age and Salary
-- of employees living in Varanasi having
-- salary more than 50000.

SELECT Employee_ID, Name, Age, Salary
FROM Employee
WHERE City = 'Varanasi'
AND Salary > 50000;


-- Q6
-- List Name, Age and Salary of employees
-- living in Varanasi having age more than 50.

SELECT Name, Age, Salary
FROM Employee
WHERE City = 'Varanasi'
AND Age > 50;


-- Q7
-- List Name and Salary of employees who
-- live either in Varanasi or Lucknow.

SELECT Name, Salary
FROM Employee
WHERE City IN ('Varanasi', 'Lucknow');


-- Q8
-- List Name, Age and Salary of employees
-- getting salary between 20000 and 50000.

SELECT Name, Age, Salary
FROM Employee
WHERE Salary BETWEEN 20000 AND 50000;


-- Q9
-- List Employee_ID, Name and Salary of
-- employees from Germany, France or Japan.

SELECT Employee_ID, Name, Salary
FROM Employee
WHERE Country IN ('Germany', 'France', 'Japan');


-- Q10
-- List Employee_ID, Name and Salary of
-- employees not from China, South Korea
-- or North Korea.

SELECT Employee_ID, Name, Salary
FROM Employee
WHERE Country NOT IN ('China', 'South Korea', 'North Korea');


-- Q11
-- List Name and Salary of employees whose
-- name starts with letter P.

SELECT Name, Salary
FROM Employee
WHERE Name LIKE 'P%';


-- Q12
-- List Name and Age of employees whose
-- name ends with letter a.

SELECT Name, Age
FROM Employee
WHERE Name LIKE '%a';


-- Q13
-- List Name and Age of employees whose
-- country name has 'n' as the 4th letter.

SELECT Name, Age
FROM Employee
WHERE Country LIKE '___n%';


-- Q14
-- List Name and City of employees having
-- Gmail email IDs.

SELECT Name, City
FROM Employee
WHERE Email_id LIKE '%@gmail.com';


-- Q15
-- List distinct country names of employees.

SELECT DISTINCT Country
FROM Employee;