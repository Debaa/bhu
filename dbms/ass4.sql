CREATE DATABASE airline_db;

USE airline_db;

CREATE TABLE Aircraft (
    aid INT PRIMARY KEY,
    aname VARCHAR(50),
    cruising_range INT
);

CREATE TABLE Employees (
    emp_id INT PRIMARY KEY,
    ename VARCHAR(50),
    salary DECIMAL(10,2)
);

CREATE TABLE Certified (
    emp_id INT,
    aid INT,

    PRIMARY KEY (emp_id, aid),

    FOREIGN KEY (emp_id)
    REFERENCES Employees(emp_id),

    FOREIGN KEY (aid)
    REFERENCES Aircraft(aid)
);

CREATE TABLE Flights (
    flno INT PRIMARY KEY,
    aid INT,
    from_city VARCHAR(50),
    to_city VARCHAR(50),
    distance INT,
    departs_time TIME,
    arrival_time TIME,
    price DECIMAL(10,2),

    FOREIGN KEY (aid)
    REFERENCES Aircraft(aid)
);



INSERT INTO Aircraft VALUES
(123, 'Airbus', 1000),
(302, 'Boeing', 5000),
(306, 'Jet01', 5000),
(378, 'Airbus380', 8000),
(456, 'Aircraft', 500),
(789, 'Aircraft02', 800),
(951, 'Aircraft03', 1000);


INSERT INTO Employees VALUES
(1, 'Ajay', 30000),
(2, 'Ajith', 85000),
(3, 'Arnab', 50000),
(4, 'Harry', 45000),
(5, 'Ron', 90000),
(6, 'Josh', 75000),
(7, 'Ram', 100000);


INSERT INTO Certified VALUES
(1, 123),
(2, 123),
(1, 302),
(5, 302),
(7, 302),
(1, 306),
(2, 306),
(1, 378),
(2, 378),
(4, 378),
(3, 456),
(6, 456),
(1, 789),
(5, 789),
(6, 789),
(1, 951),
(3, 951);


INSERT INTO Flights VALUES
(1, 123, 'Bangalore', 'Mangalore', 360, '10:45:00', '12:00:00', 10000),
(2, 302, 'Bangalore', 'Delhi', 5000, '12:15:00', '04:30:00', 25000),
(3, 306, 'Bangalore', 'Mumbai', 3500, '02:15:00', '05:25:00', 30000),
(4, 378, 'Delhi', 'Mumbai', 4500, '10:15:00', '12:05:00', 35000),
(5, 302, 'Delhi', 'Frankfurt', 18000, '07:15:00', '05:30:00', 90000),
(6, 378, 'Bangalore', 'Frankfurt', 19500, '10:00:00', '07:45:00', 95000),
(7, 306, 'Bangalore', 'Frankfurt', 17000, '12:00:00', '06:30:00', 99000);



-- Q1
-- Find the names of aircraft such that all
-- pilots certified to operate them earn
-- more than 80000.

SELECT a.aname
FROM Aircraft a
JOIN Certified c
ON a.aid = c.aid
JOIN Employees e
ON c.emp_id = e.emp_id
GROUP BY a.aname
HAVING MIN(e.salary) > 80000;


-- Q2
-- For each pilot certified for more than
-- three aircraft find emp_id and maximum
-- cruising range.

SELECT c.emp_id,
MAX(a.cruising_range) AS max_range
FROM Certified c
JOIN Aircraft a
ON c.aid = a.aid
GROUP BY c.emp_id
HAVING COUNT(c.aid) > 3;


-- Q3
-- Find names of pilots whose salary is less
-- than the cheapest route from Los Angeles
-- to Honolulu.

SELECT ename
FROM Employees
WHERE salary < (
    SELECT MIN(price)
    FROM Flights
    WHERE from_city = 'Los Angeles'
    AND to_city = 'Honolulu'
);


-- Q4
-- For aircraft with cruising range greater
-- than 1000 find aircraft name and average
-- salary of certified pilots.

SELECT a.aname,
AVG(e.salary) AS avg_salary
FROM Aircraft a
JOIN Certified c
ON a.aid = c.aid
JOIN Employees e
ON c.emp_id = e.emp_id
WHERE a.cruising_range > 1000
GROUP BY a.aname;


-- Q5
-- Find names of pilots certified for
-- some Boeing aircraft.

SELECT DISTINCT e.ename
FROM Employees e
JOIN Certified c
ON e.emp_id = c.emp_id
JOIN Aircraft a
ON c.aid = a.aid
WHERE a.aname LIKE 'Boeing%';


-- Q6
-- Find aids of aircraft that can be used
-- on routes from Los Angeles to Chicago.

SELECT DISTINCT a.aid
FROM Aircraft a
JOIN Flights f
ON a.aid = f.aid
WHERE f.from_city = 'Los Angeles'
AND f.to_city = 'Chicago'
AND a.cruising_range >= f.distance;


-- Q7
-- Identify routes that can be piloted by
-- every pilot earning more than 100000.

SELECT DISTINCT f.from_city, f.to_city
FROM Flights f
WHERE NOT EXISTS (
    SELECT *
    FROM Employees e
    WHERE e.salary > 100000
    AND NOT EXISTS (
        SELECT *
        FROM Certified c
        JOIN Aircraft a
        ON c.aid = a.aid
        WHERE c.emp_id = e.emp_id
        AND a.cruising_range >= f.distance
    )
);


-- Q8
-- Print names of pilots who can operate
-- planes with cruising range greater than
-- 3000 but are not certified on Boeing aircraft.

SELECT DISTINCT e.ename
FROM Employees e
JOIN Certified c
ON e.emp_id = c.emp_id
JOIN Aircraft a
ON c.aid = a.aid
WHERE a.cruising_range > 3000
AND e.emp_id NOT IN (
    SELECT c2.emp_id
    FROM Certified c2
    JOIN Aircraft a2
    ON c2.aid = a2.aid
    WHERE a2.aname LIKE 'Boeing%'
);


-- Q9
-- Find departure times from Madison to
-- New York with at most one stop arriving
-- before 6 PM.

SELECT DISTINCT f1.departs_time
FROM Flights f1
WHERE f1.from_city = 'Madison'
AND f1.to_city = 'New York'
AND f1.arrival_time < '18:00:00'

UNION

SELECT DISTINCT f1.departs_time
FROM Flights f1
JOIN Flights f2
ON f1.to_city = f2.from_city
WHERE f1.from_city = 'Madison'
AND f2.to_city = 'New York'
AND f2.arrival_time < '18:00:00';


-- Q10
-- Compute difference between average
-- pilot salary and average employee salary.

SELECT
(
    SELECT AVG(e.salary)
    FROM Employees e
    JOIN Certified c
    ON e.emp_id = c.emp_id
)
-
(
    SELECT AVG(salary)
    FROM Employees
) AS salary_difference;


-- Q11
-- Print name and salary of every nonpilot
-- whose salary is more than average salary
-- of pilots.

SELECT ename, salary
FROM Employees
WHERE emp_id NOT IN (
    SELECT emp_id
    FROM Certified
)
AND salary > (
    SELECT AVG(e.salary)
    FROM Employees e
    JOIN Certified c
    ON e.emp_id = c.emp_id
);