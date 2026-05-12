-- =========================================================
-- SET-2 : SQL QUERIES
-- =========================================================



-- =========================================================
-- Q1
-- Find the total number of people who owned cars
-- that were not involved in accidents in 2024.
-- =========================================================

SELECT COUNT(DISTINCT o.driver_id) AS total_people
FROM owns o
WHERE o.license NOT IN (
    SELECT p.license
    FROM participated p
    JOIN accident a
    ON p.report_number = a.report_number
    WHERE YEAR(a.accident_date) = 2024
);



-- =========================================================
-- Q2
-- Find the number of accidents in which the cars
-- of model Hyundai were involved.
-- =========================================================

SELECT COUNT(*) AS total_accidents
FROM car c
JOIN participated p
ON c.license = p.license
WHERE c.model = 'Hyundai';



-- =========================================================
-- Q3
-- Find the location that has the maximum accidents.
-- =========================================================

SELECT location
FROM accident
GROUP BY location
HAVING COUNT(*) = (
    SELECT MAX(acc_count)
    FROM (
        SELECT COUNT(*) AS acc_count
        FROM accident
        GROUP BY location
    ) AS temp
);



-- =========================================================
-- Q4
-- Find the year and the location of accidents where
-- the damage_amount is greater than Rs. 5000.
-- =========================================================

SELECT YEAR(a.accident_date) AS year,
a.location
FROM accident a
JOIN participated p
ON a.report_number = p.report_number
WHERE p.damage_amount > 5000;



-- =========================================================
-- Q5
-- Find all the drivers name who caused car
-- accident in Lucknow.
-- =========================================================

SELECT DISTINCT pe.name
FROM person pe
JOIN participated p
ON pe.driver_id = p.driver_id
JOIN accident a
ON p.report_number = a.report_number
WHERE a.location = 'Lucknow';



-- =========================================================
-- Q6
-- Find all car models which did not make any accident.
-- =========================================================

SELECT model
FROM car
WHERE license NOT IN (
    SELECT license
    FROM participated
);




-- =========================================================
-- SAMPLE DATA FOR SET-2
-- =========================================================

USE accident_db;

-- PERSON DATA
INSERT INTO person VALUES
(1, 'Amit Sharma', 'Delhi'),
(2, 'Rohit Das', 'Mumbai'),
(3, 'Priya Roy', 'Lucknow'),
(4, 'Anil Kumar', 'Kolkata'),
(5, 'Sneha Jain', 'Bhubaneswar'),
(6, 'Vikas Singh', 'Patna');



-- CAR DATA
INSERT INTO car VALUES
('DL01AA1111', 'Hyundai', 2020),
('MH02BB2222', 'Honda City', 2019),
('UP03CC3333', 'Hyundai', 2021),
('WB04DD4444', 'Toyota', 2018),
('OD05EE5555', 'Maruti Suzuki', 2022),
('BR06FF6666', 'Tata Nexon', 2023);



-- ACCIDENT DATA
INSERT INTO accident VALUES
(201, '2024-01-15', 'Lucknow'),
(202, '2023-06-20', 'Delhi'),
(203, '2024-03-18', 'Mumbai'),
(204, '2022-08-11', 'Lucknow'),
(205, '2021-12-05', 'Kolkata');



-- OWNS DATA
INSERT INTO owns VALUES
(1, 'DL01AA1111'),
(2, 'MH02BB2222'),
(3, 'UP03CC3333'),
(4, 'WB04DD4444'),
(5, 'OD05EE5555'),
(6, 'BR06FF6666');



-- PARTICIPATED DATA
INSERT INTO participated VALUES
(1, 'DL01AA1111', 201, 7000),
(2, 'MH02BB2222', 202, 4000),
(3, 'UP03CC3333', 203, 9000),
(4, 'WB04DD4444', 204, 3000),
(5, 'OD05EE5555', 205, 6000);