-- =========================================================
-- LAB2TB : TABLE CREATION
-- =========================================================

CREATE DATABASE property_db;

USE property_db;

CREATE TABLE Branch (
    branchNo VARCHAR(10) PRIMARY KEY,
    city VARCHAR(50)
);

CREATE TABLE Staff (
    staffNo VARCHAR(10) PRIMARY KEY,
    Name VARCHAR(50),
    position VARCHAR(20),
    gender VARCHAR(10),
    DOB DATE,
    salary DECIMAL(10,2),
    branchNo VARCHAR(10),

    FOREIGN KEY (branchNo)
    REFERENCES Branch(branchNo)
);

CREATE TABLE Owner (
    ownerNo VARCHAR(10) PRIMARY KEY,
    Name VARCHAR(50),
    Address VARCHAR(100),
    contact_no VARCHAR(15)
);

CREATE TABLE Property (
    propertyNo VARCHAR(10) PRIMARY KEY,
    city VARCHAR(50),
    type VARCHAR(20),
    rent DECIMAL(10,2),
    ownerNo VARCHAR(10),
    staffNo VARCHAR(10),
    branchNo VARCHAR(10),

    FOREIGN KEY (ownerNo)
    REFERENCES Owner(ownerNo),

    FOREIGN KEY (staffNo)
    REFERENCES Staff(staffNo),

    FOREIGN KEY (branchNo)
    REFERENCES Branch(branchNo)
);



-- =========================================================
-- LAB2Q1
-- List all male staff details working in Mumbai
-- and salary greater than Rs. 80,000.
-- =========================================================

SELECT *
FROM Staff
WHERE gender = 'Male'
AND salary > 80000
AND branchNo IN (
    SELECT branchNo
    FROM Branch
    WHERE city = 'Mumbai'
);



-- =========================================================
-- LAB2Q2
-- List all male managers working either in
-- New Delhi or Kolkata.
-- =========================================================

SELECT *
FROM Staff s
JOIN Branch b
ON s.branchNo = b.branchNo
WHERE s.position = 'Manager'
AND b.city IN ('New Delhi', 'Kolkata');



-- =========================================================
-- LAB2Q3
-- List all flats with rent below Rs. 4000
-- per day in ascending order of price.
-- =========================================================

SELECT *
FROM Property
WHERE type = 'Flat'
AND rent < 4000
ORDER BY rent ASC;



-- =========================================================
-- LAB2Q4
-- Find all owners with the string 'Lucknow'
-- in their address.
-- =========================================================

SELECT *
FROM Owner
WHERE Address LIKE '%Lucknow%';



-- =========================================================
-- LAB2Q5
-- Display the total salary of all male staff.
-- =========================================================

SELECT SUM(salary) AS total_salary
FROM Staff
WHERE gender = 'Male';



-- =========================================================
-- LAB2Q6
-- Find how many properties cost more than
-- Rs. 3500 to rent.
-- =========================================================

SELECT COUNT(*) AS total_properties
FROM Property
WHERE rent > 3500;



-- =========================================================
-- LAB2Q7
-- Find the total number of Managers and
-- the sum of their salaries.
-- =========================================================

SELECT COUNT(*) AS total_managers,
SUM(salary) AS total_salary
FROM Staff
WHERE position = 'Manager';



-- =========================================================
-- LAB2Q8
-- Find the staff name who has salary higher
-- than the average salary of branch BR003.
-- =========================================================

SELECT Name
FROM Staff
WHERE salary > (
    SELECT AVG(salary)
    FROM Staff
    WHERE branchNo = 'BR003'
);



-- =========================================================
-- LAB2Q9
-- Give all Managers a 5% pay increase.
-- =========================================================

UPDATE Staff
SET salary = salary + (salary * 0.05)
WHERE position = 'Manager';