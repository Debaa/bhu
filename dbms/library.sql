CREATE DATABASE library_db;
USE library_db;

CREATE TABLE books (
    accession_no INT,
    book_title VARCHAR(100),
    author VARCHAR(100),
    price_inr DECIMAL(10,2),
    price_dollar DECIMAL(10,2),
    price_pound DECIMAL(10,2),
    publisher VARCHAR(100),
    status VARCHAR(30),
    donated VARCHAR(30),
    self_no VARCHAR(50),
    compartment_no INT,
    no_of_copy INT
);

DESC books;
