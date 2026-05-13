CREATE DATABASE library_db;

USE library_db;

CREATE TABLE Books (
    book_id INT PRIMARY KEY,
    title VARCHAR(100),
    author VARCHAR(100),
    published_year DATE,
    genre VARCHAR(100),
    available_copies INT
);

CREATE TABLE Members (
    member_id INT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100),
    age INT,
    gender VARCHAR(10)
);

CREATE TABLE Borrowed (
    borrow_id INT PRIMARY KEY,
    book_id INT,
    member_id INT,
    borrow_date DATE,
    return_date DATE,

    FOREIGN KEY (book_id)
    REFERENCES Books(book_id),

    FOREIGN KEY (member_id)
    REFERENCES Members(member_id)
);



INSERT INTO Books VALUES
(551, 'The_Great_Gatsby', 'F_Scott_Fitzgerald', '1925-04-10', 'Tragedy', 10000),
(552, 'ULYSSES', 'James_Joyce', '1922-02-02', 'Modernist_Novel', 10000),
(553, 'Lolita', 'Vladimir_Nabokov', '1955-01-20', 'Novel', 10000),
(554, 'Brave_New_World', 'Aldous_Huxley', '1932-05-05', 'Science_Fiction', 10000),
(555, 'The_Sound_And_The_Fury', 'William_Faulkner', '1929-03-01', 'Southern_Gothic', 10000),
(556, 'Catch22', 'Joseph_Heller', '1961-10-10', 'Dark_Comedy', 10000),
(557, 'The_Grapes_Of_Wrath', 'John_Steinbeck', '1939-04-14', 'Novel', 10000),
(558, 'I_Claudius', 'Robert_Graves', '1934-08-10', 'Historical', 10000),
(559, 'To_The_Lighthouse', 'Virginia_Woolf', '1927-05-05', 'Modernism', 10000),
(5510, 'Slaughterhouse_Five', 'Kurt_Vonnegut', '1969-03-31', 'War_Novel', 10000);


INSERT INTO Members VALUES
(1, 'John Smith', 'john@gmail.com', 25, 'Male'),
(2, 'Alice Brown', 'alice@gmail.com', 30, 'Female'),
(3, 'David Roy', 'david@gmail.com', 65, 'Male'),
(4, 'Sophia Das', 'sophia@gmail.com', 70, 'Female'),
(5, 'Michael Lee', 'michael@gmail.com', 40, 'Male');


INSERT INTO Borrowed VALUES
(101, 551, 1, '2025-01-01', '2025-01-10'),
(102, 552, 2, '2025-01-05', '2025-01-20'),
(103, 553, 3, '2025-02-01', NULL),
(104, 554, 4, '2025-02-10', '2025-02-15'),
(105, 555, 5, '2025-03-01', NULL);



-- Q1
-- Get a list of books borrowed by John Smith.

SELECT b.title
FROM Books b
JOIN Borrowed br
ON b.book_id = br.book_id
JOIN Members m
ON br.member_id = m.member_id
WHERE m.name = 'John Smith';



-- Q2
-- Find members who borrowed Atomic Habits.

SELECT m.name
FROM Members m
JOIN Borrowed br
ON m.member_id = br.member_id
JOIN Books b
ON br.book_id = b.book_id
WHERE b.title = 'Atomic Habits';



-- Q3
-- List genre wise available copies of books.

SELECT genre,
SUM(available_copies) AS total_copies
FROM Books
GROUP BY genre;



-- Q4
-- Find the genre most liked by female members.

SELECT b.genre
FROM Books b
JOIN Borrowed br
ON b.book_id = br.book_id
JOIN Members m
ON br.member_id = m.member_id
WHERE m.gender = 'Female'
GROUP BY b.genre
ORDER BY COUNT(*) DESC
LIMIT 1;



-- Q5
-- Find the genre most liked by senior citizens.

SELECT b.genre
FROM Books b
JOIN Borrowed br
ON b.book_id = br.book_id
JOIN Members m
ON br.member_id = m.member_id
WHERE m.age >= 60
GROUP BY b.genre
ORDER BY COUNT(*) DESC
LIMIT 1;



-- Q6
-- Find members who returned books within 14 days.

SELECT DISTINCT m.name
FROM Members m
JOIN Borrowed br
ON m.member_id = br.member_id
WHERE DATEDIFF(br.return_date, br.borrow_date) <= 14;



-- Q7
-- Find overdue books and member names.

SELECT b.title, m.name
FROM Books b
JOIN Borrowed br
ON b.book_id = br.book_id
JOIN Members m
ON br.member_id = m.member_id
WHERE br.return_date IS NULL
AND DATEDIFF(CURDATE(), br.borrow_date) > 14;



-- Q8
-- Find the most popular genre in the library.

SELECT b.genre
FROM Books b
JOIN Borrowed br
ON b.book_id = br.book_id
GROUP BY b.genre
ORDER BY COUNT(*) DESC
LIMIT 1;



-- Q9
-- Add fine_amount column to Borrowed table.

ALTER TABLE Borrowed
ADD fine_amount DECIMAL(10,2) DEFAULT 0;



-- Q10
-- Calculate total fines from overdue books.

SELECT SUM(fine_amount) AS total_fine
FROM Borrowed
WHERE return_date IS NULL
AND DATEDIFF(CURDATE(), borrow_date) > 14;



-- Q11
-- Find top 5 members who borrowed most books.

SELECT m.name,
COUNT(br.borrow_id) AS total_books
FROM Members m
JOIN Borrowed br
ON m.member_id = br.member_id
GROUP BY m.name
ORDER BY total_books DESC
LIMIT 5;



-- Q12
-- Add unique constraint on book_id and member_id.

ALTER TABLE Borrowed
ADD CONSTRAINT unique_book_member
UNIQUE(book_id, member_id);



-- Q13
-- Find books available for borrowing.

SELECT title, available_copies
FROM Books
WHERE available_copies > 0;



-- Q14
-- Categorize members using CASE statement.

SELECT m.name,
COUNT(br.borrow_id) AS total_books,
CASE
    WHEN COUNT(br.borrow_id) > 10 THEN 'Frequent Borrowers'
    WHEN COUNT(br.borrow_id) BETWEEN 5 AND 10 THEN 'Regular Borrowers'
    ELSE 'Occasional Borrowers'
END AS category
FROM Members m
JOIN Borrowed br
ON m.member_id = br.member_id
GROUP BY m.name;



-- Q15
-- Find members returning books in less than 7 days.

SELECT m.name,
AVG(DATEDIFF(br.return_date, br.borrow_date)) AS avg_days
FROM Members m
JOIN Borrowed br
ON m.member_id = br.member_id
WHERE br.return_date IS NOT NULL
GROUP BY m.name
HAVING AVG(DATEDIFF(br.return_date, br.borrow_date)) < 7;



-- Q16
-- Trigger to decrease available copies after issue.

CREATE TRIGGER update_copies_after_issue
AFTER INSERT ON Borrowed
FOR EACH ROW
UPDATE Books
SET available_copies = available_copies - 1
WHERE book_id = NEW.book_id;



-- Q17
-- Trigger to increase available copies after return.

CREATE TRIGGER update_copies_after_return
AFTER UPDATE ON Borrowed
FOR EACH ROW
UPDATE Books
SET available_copies = available_copies + 1
WHERE book_id = NEW.book_id
AND NEW.return_date IS NOT NULL;