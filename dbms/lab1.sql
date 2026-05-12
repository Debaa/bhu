-- =========================================================
-- LAB1TB : TABLE CREATION
-- =========================================================

CREATE DATABASE college_db;
USE college_db;

CREATE TABLE student (
    sid INT PRIMARY KEY,
    sname VARCHAR(50),
    gender VARCHAR(10),
    age INT,
    gpa DECIMAL(3,2)
);

CREATE TABLE professor (
    prof_ssn INT PRIMARY KEY,
    prof_name VARCHAR(50),
    age INT,
    city VARCHAR(50),
    salary DECIMAL(10,2)
);

CREATE TABLE department (
    dept_name VARCHAR(50) PRIMARY KEY,
    hod_ssn INT,
    dept_email VARCHAR(100),
    year_of_establishment INT,

    FOREIGN KEY (hod_ssn)
    REFERENCES professor(prof_ssn)
);

CREATE TABLE course (
    course_no INT PRIMARY KEY,
    cname VARCHAR(50),
    dname VARCHAR(50),
    prof_ssn INT,

    FOREIGN KEY (dname)
    REFERENCES department(dept_name),

    FOREIGN KEY (prof_ssn)
    REFERENCES professor(prof_ssn)
);

CREATE TABLE enroll (
    sid INT,
    dept_name VARCHAR(50),
    course_no INT,

    PRIMARY KEY (sid, course_no),

    FOREIGN KEY (sid)
    REFERENCES student(sid),

    FOREIGN KEY (dept_name)
    REFERENCES department(dept_name),

    FOREIGN KEY (course_no)
    REFERENCES course(course_no)
);



-- =========================================================
-- LAB1Q1
-- List the name of all the professors who teach only
-- for Computer Science department and whose name
-- starts with letter 'A'.
-- =========================================================

SELECT DISTINCT p.prof_name
FROM professor p
JOIN course c
ON p.prof_ssn = c.prof_ssn
WHERE p.prof_name LIKE 'A%'
GROUP BY p.prof_ssn, p.prof_name
HAVING COUNT(DISTINCT c.dname) = 1
AND MAX(c.dname) = 'Computer Science';



-- =========================================================
-- LAB1Q2
-- Print the names of those male students who are
-- taking both a Civil Engineering course and a
-- Computer Science course.
-- =========================================================

SELECT DISTINCT s.sname
FROM student s
JOIN enroll e1
ON s.sid = e1.sid
JOIN course c1
ON e1.course_no = c1.course_no
JOIN enroll e2
ON s.sid = e2.sid
JOIN course c2
ON e2.course_no = c2.course_no
WHERE s.gender = 'Male'
AND c1.dname = 'Civil Engineering'
AND c2.dname = 'Computer Science';



-- =========================================================
-- LAB1Q3
-- Print the sids, name and gpa of the female students
-- not older than 23 years who are currently taking the
-- Civil Engineering courses.
-- =========================================================

SELECT DISTINCT s.sid, s.sname, s.gpa
FROM student s
JOIN enroll e
ON s.sid = e.sid
JOIN course c
ON e.course_no = c.course_no
WHERE s.gender = 'Female'
AND s.age <= 23
AND c.dname = 'Civil Engineering';



-- =========================================================
-- LAB1Q4
-- List the name of department having most male students.
-- =========================================================

SELECT e.dept_name
FROM enroll e
JOIN student s
ON e.sid = s.sid
WHERE s.gender = 'Male'
GROUP BY e.dept_name
HAVING COUNT(*) = (
    SELECT MAX(cnt)
    FROM (
        SELECT COUNT(*) AS cnt
        FROM enroll e1
        JOIN student s1
        ON e1.sid = s1.sid
        WHERE s1.gender = 'Male'
        GROUP BY e1.dept_name
    ) AS temp
);



-- =========================================================
-- LAB1Q5
-- List the name of the department and its head name
-- which is offering minimum number of courses.
-- =========================================================

SELECT d.dept_name, p.prof_name
FROM department d
JOIN professor p
ON d.hod_ssn = p.prof_ssn
JOIN course c
ON d.dept_name = c.dname
GROUP BY d.dept_name, p.prof_name
HAVING COUNT(c.course_no) = (
    SELECT MIN(cnt)
    FROM (
        SELECT COUNT(*) AS cnt
        FROM course
        GROUP BY dname
    ) AS temp
);



-- =========================================================
-- LAB1Q6
-- For each Civil Engineering department course,
-- print the course number, course name and professor
-- name teaching that course.
-- =========================================================

SELECT c.course_no, c.cname, p.prof_name
FROM course c
JOIN professor p
ON c.prof_ssn = p.prof_ssn
WHERE c.dname = 'Civil Engineering';






-- =========================================
-- LAB1 SAMPLE DATA
-- =========================================

USE college_db;

-- PROFESSOR DATA
INSERT INTO professor VALUES
(101, 'Vandana Kushwaha', 45, 'Delhi', 90000),
(102, 'Anil Verma', 50, 'Mumbai', 95000),
(103, 'Rakesh Das', 42, 'Kolkata', 85000),
(104, 'Priya Roy', 39, 'Bhubaneswar', 80000),
(105, 'Sunita Jain', 48, 'Chennai', 92000);

-- DEPARTMENT DATA
INSERT INTO department VALUES
('Computer Science', 101, 'cs@college.com', 2001),
('Civil Engineering', 103, 'civil@college.com', 1998),
('Mechanical', 105, 'mech@college.com', 1995);

-- COURSE DATA
INSERT INTO course VALUES
(201, 'DBMS', 'Computer Science', 101),
(202, 'Operating System', 'Computer Science', 102),
(203, 'Surveying', 'Civil Engineering', 103),
(204, 'Structural Analysis', 'Civil Engineering', 104),
(205, 'Thermodynamics', 'Mechanical', 105);

-- STUDENT DATA
INSERT INTO student VALUES
(1, 'Rahul', 'Male', 22, 8.50),
(2, 'Sneha', 'Female', 21, 9.10),
(3, 'Arjun', 'Male', 24, 7.80),
(4, 'Pooja', 'Female', 23, 8.90),
(5, 'Karan', 'Male', 20, 7.50);

-- ENROLL DATA
INSERT INTO enroll VALUES
(1, 'Computer Science', 201),
(1, 'Civil Engineering', 203),
(2, 'Civil Engineering', 203),
(2, 'Civil Engineering', 204),
(3, 'Mechanical', 205),
(4, 'Civil Engineering', 204),
(5, 'Computer Science', 202),
(5, 'Civil Engineering', 203);