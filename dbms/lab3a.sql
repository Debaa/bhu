-- =========================================================
-- SET-1 : TABLE CREATION
-- =========================================================

CREATE DATABASE accident_db;

USE accident_db;

-- PERSON TABLE
CREATE TABLE person (
    driver_id INT PRIMARY KEY,
    name VARCHAR(50),
    address VARCHAR(100)
);

-- CAR TABLE
CREATE TABLE car (
    license VARCHAR(20) PRIMARY KEY,
    model VARCHAR(50),
    year INT
);

-- ACCIDENT TABLE
CREATE TABLE accident (
    report_number INT PRIMARY KEY,
    accident_date DATE,
    location VARCHAR(100)
);

-- OWNS TABLE
CREATE TABLE owns (
    driver_id INT,
    license VARCHAR(20),

    PRIMARY KEY (driver_id, license),

    FOREIGN KEY (driver_id)
    REFERENCES person(driver_id),

    FOREIGN KEY (license)
    REFERENCES car(license)
);

-- PARTICIPATED TABLE
CREATE TABLE participated (
    driver_id INT,
    license VARCHAR(20),
    report_number INT,
    damage_amount DECIMAL(10,2),

    PRIMARY KEY (driver_id, license, report_number),

    FOREIGN KEY (driver_id)
    REFERENCES person(driver_id),

    FOREIGN KEY (license)
    REFERENCES car(license),

    FOREIGN KEY (report_number)
    REFERENCES accident(report_number)
);



-- =========================================================
-- Q1
-- Find the total number of people who owned cars
-- that were involved in accidents in 2024.
-- =========================================================

SELECT COUNT(DISTINCT o.driver_id) AS total_people
FROM owns o
JOIN participated p
ON o.license = p.license
JOIN accident a
ON p.report_number = a.report_number
WHERE YEAR(a.accident_date) = 2024;



-- =========================================================
-- Q2
-- Add a new accident to the database; assume any
-- values for required attributes.
-- =========================================================

INSERT INTO accident
VALUES (101, '2024-05-15', 'Bhubaneswar');



-- =========================================================
-- Q3
-- Find the number of accidents in which the cars
-- belonging to "Steve Joes" were involved.
-- =========================================================

SELECT COUNT(*) AS total_accidents
FROM person pe
JOIN owns o
ON pe.driver_id = o.driver_id
JOIN participated p
ON o.license = p.license
WHERE pe.name = 'Steve Joes';



-- =========================================================
-- Q4
-- Find the car model and the location of accidents
-- where the damage_amount is highest.
-- =========================================================

SELECT c.model, a.location
FROM participated p
JOIN car c
ON p.license = c.license
JOIN accident a
ON p.report_number = a.report_number
WHERE p.damage_amount = (
    SELECT MAX(damage_amount)
    FROM participated
);



-- =========================================================
-- Q5
-- Find all drivers who did not make any accident.
-- =========================================================

SELECT *
FROM person
WHERE driver_id NOT IN (
    SELECT driver_id
    FROM participated
);



-- =========================================================
-- Q6
-- Find all the car models which were damaged by
-- accident during last five years.
-- =========================================================

SELECT DISTINCT c.model
FROM car c
JOIN participated p
ON c.license = p.license
JOIN accident a
ON p.report_number = a.report_number
WHERE YEAR(a.accident_date) >= YEAR(CURDATE()) - 5;


-- =========================================================
-- SAMPLE DATA FOR accident_db
-- =========================================================

USE accident_db;

INSERT INTO person VALUES
(1, 'Steve Joes', 'Delhi'),
(2, 'Rahul Sharma', 'Mumbai'),
(3, 'Anita Das', 'Kolkata'),
(4, 'Vikas Roy', 'Lucknow'),
(5, 'Pooja Singh', 'Bhubaneswar');


INSERT INTO car VALUES
('OD01A1234', 'Hyundai', 2020),
('DL02B5678', 'Honda City', 2019),
('MH03C7890', 'Maruti Suzuki', 2022),
('WB04D4567', 'Toyota', 2021),
('UP05E9876', 'Hyundai', 2018);


INSERT INTO accident VALUES
(101, '2024-01-15', 'Delhi'),
(102, '2023-06-10', 'Mumbai'),
(103, '2022-11-05', 'Lucknow'),
(104, '2024-03-20', 'Kolkata'),
(105, '2021-09-18', 'Bhubaneswar');


INSERT INTO owns VALUES
(1, 'OD01A1234'),
(2, 'DL02B5678'),
(3, 'MH03C7890'),
(4, 'WB04D4567'),
(5, 'UP05E9876');


INSERT INTO participated VALUES
(1, 'OD01A1234', 101, 5000),
(2, 'DL02B5678', 102, 12000),
(3, 'MH03C7890', 103, 7000),
(1, 'OD01A1234', 104, 15000),
(4, 'WB04D4567', 105, 3000);

