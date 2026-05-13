CREATE DATABASE hotel_db;

USE hotel_db;

CREATE TABLE Hotel (
    Hotel_No VARCHAR(10) PRIMARY KEY,
    Name VARCHAR(50),
    City VARCHAR(50)
);

CREATE TABLE Room (
    Room_No INT,
    Hotel_No VARCHAR(10),
    Type CHAR(1),
    Price DECIMAL(10,2),

    PRIMARY KEY (Room_No, Hotel_No),

    FOREIGN KEY (Hotel_No)
    REFERENCES Hotel(Hotel_No)
);

CREATE TABLE Guest (
    Guest_No VARCHAR(10) PRIMARY KEY,
    Name VARCHAR(50),
    City VARCHAR(50)
);

CREATE TABLE Booking (
    Hotel_No VARCHAR(10),
    Room_No INT,
    Guest_No VARCHAR(10),
    Date_From DATE,
    Date_To DATE,

    PRIMARY KEY (Hotel_No, Room_No, Guest_No, Date_From),

    FOREIGN KEY (Hotel_No)
    REFERENCES Hotel(Hotel_No),

    FOREIGN KEY (Guest_No)
    REFERENCES Guest(Guest_No)
);



INSERT INTO Hotel VALUES
('H111', 'Empire Hotel', 'New York'),
('H235', 'Park Place', 'New York'),
('H432', 'Brownstone Hotel', 'Toronto'),
('H498', 'James Plaza', 'Toronto'),
('H193', 'Devon Hotel', 'Boston'),
('H437', 'Clairmont Hotel', 'Boston');


INSERT INTO Room VALUES
(313, 'H111', 'S', 145.00),
(412, 'H111', 'N', 145.00),
(1267, 'H235', 'N', 175.00),
(1289, 'H235', 'N', 195.00),
(876, 'H432', 'S', 124.00),
(898, 'H432', 'S', 124.00),
(345, 'H498', 'N', 160.00),
(467, 'H498', 'N', 180.00),
(1001, 'H193', 'S', 150.00),
(1201, 'H193', 'N', 175.00),
(257, 'H437', 'N', 140.00),
(223, 'H437', 'N', 155.00);


INSERT INTO Guest VALUES
('G256', 'Adam Wayne', 'Pittsburgh'),
('G367', 'Tara Cummings', 'Baltimore'),
('G879', 'Vanessa Parry', 'Pittsburgh'),
('G230', 'Tom Hancock', 'Philadelphia'),
('G467', 'Robert Swift', 'Atlanta'),
('G190', 'Edward Cane', 'Baltimore');


INSERT INTO Booking VALUES
('H111', 412, 'G256', '1999-08-10', '1999-08-15'),
('H111', 412, 'G367', '1999-08-18', '1999-08-21'),
('H235', 1267, 'G879', '1999-09-05', '1999-09-12'),
('H498', 467, 'G230', '1999-09-15', '1999-09-18'),
('H498', 345, 'G256', '1999-11-30', '1999-12-02'),
('H498', 345, 'G467', '1999-11-03', '1999-11-05'),
('H193', 1001, 'G190', '1999-11-15', '1999-11-19'),
('H193', 1001, 'G367', '1999-09-12', '1999-09-14'),
('H193', 1201, 'G367', '1999-10-01', '1999-10-06'),
('H437', 223, 'G190', '1999-10-04', '1999-10-06'),
('H437', 223, 'G879', '1999-09-14', '1999-09-17');


-- Q1
-- List full details of all hotels.

SELECT *
FROM Hotel;


-- Q2
-- List full details of all hotels in New York.

SELECT *
FROM Hotel
WHERE City = 'New York';


-- Q3
-- List the names and cities of all guests,
-- ordered according to their cities.

SELECT Name, City
FROM Guest
ORDER BY City;


-- Q4
-- List all details for family rooms
-- in ascending order of price.

SELECT *
FROM Room
WHERE Type = 'N'
ORDER BY Price;


-- Q5
-- List the number of hotels there are.

SELECT COUNT(*) AS total_hotels
FROM Hotel;


-- Q6
-- List the cities in which guests live.
-- Each city should be listed only once.

SELECT DISTINCT City
FROM Guest;


-- Q7
-- List the average price of a room.

SELECT AVG(Price) AS average_price
FROM Room;


-- Q8
-- List hotel names, their room numbers,
-- and the type of that room.

SELECT h.Name, r.Room_No, r.Type
FROM Hotel h
JOIN Room r
ON h.Hotel_No = r.Hotel_No;


-- Q9
-- List the hotel names, booking dates,
-- and room numbers for all hotels in New York.

SELECT h.Name, b.Date_From, b.Room_No
FROM Hotel h
JOIN Booking b
ON h.Hotel_No = b.Hotel_No
WHERE h.City = 'New York';


-- Q10
-- What is the number of bookings that
-- started in the month of September?

SELECT COUNT(*) AS total_bookings
FROM Booking
WHERE MONTH(Date_From) = 9;


-- Q11
-- List the names and cities of guests
-- who began a stay in New York in August.

SELECT g.Name, g.City
FROM Guest g
JOIN Booking b
ON g.Guest_No = b.Guest_No
JOIN Hotel h
ON b.Hotel_No = h.Hotel_No
WHERE h.City = 'New York'
AND MONTH(b.Date_From) = 8;


-- Q12
-- List the hotel names and room numbers
-- of any hotel rooms that have not been booked.

SELECT h.Name, r.Room_No
FROM Hotel h
JOIN Room r
ON h.Hotel_No = r.Hotel_No
WHERE (r.Room_No, r.Hotel_No) NOT IN (
    SELECT Room_No, Hotel_No
    FROM Booking
);


-- Q13
-- List the hotel name and city of the hotel
-- with the highest priced room.

SELECT h.Name, h.City
FROM Hotel h
JOIN Room r
ON h.Hotel_No = r.Hotel_No
WHERE r.Price = (
    SELECT MAX(Price)
    FROM Room
);


-- Q14
-- List hotel names, room numbers, cities,
-- and prices for hotels that have rooms
-- with prices lower than the lowest priced
-- room in a Boston hotel.

SELECT h.Name, r.Room_No, h.City, r.Price
FROM Hotel h
JOIN Room r
ON h.Hotel_No = r.Hotel_No
WHERE r.Price < (
    SELECT MIN(r2.Price)
    FROM Room r2
    JOIN Hotel h2
    ON r2.Hotel_No = h2.Hotel_No
    WHERE h2.City = 'Boston'
);


-- Q15
-- List the average price of a room grouped by city.

SELECT h.City, AVG(r.Price) AS average_price
FROM Hotel h
JOIN Room r
ON h.Hotel_No = r.Hotel_No
GROUP BY h.City;