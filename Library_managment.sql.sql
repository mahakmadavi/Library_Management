-- LIBRARY MANAGEMENT PROJECT
-- 1. MEMBERS TABLE

CREATE TABLE members
(
    member_id INT PRIMARY KEY,
    member_name VARCHAR(50) NOT NULL,
    city VARCHAR(30),
    age INT CHECK (age >= 10)
);


-- 2. BOOKS TABLE

CREATE TABLE books
(
    book_id INT PRIMARY KEY,
    book_name VARCHAR(100) NOT NULL,
    author VARCHAR(50) NOT NULL,
    category VARCHAR(30),
    price INT CHECK (price > 0)
);


-- 3. BORROW RECORDS TABLE

CREATE TABLE borrow_records
(
    borrow_id INT PRIMARY KEY,
    member_id INT,
    book_id INT,
    borrow_date DATE,
    return_date DATE,

    FOREIGN KEY (member_id)
    REFERENCES members(member_id),

    FOREIGN KEY (book_id)
    REFERENCES books(book_id)
);


-- 4. INSERT DATA INTO MEMBERS

INSERT INTO members
(member_id, member_name, city, age)
VALUES
(1, 'Aman', 'Nagpur', 20),
(2, 'Riya', 'Wardha', 21),
(3, 'Karan', 'Bhopal', 19),
(4, 'Neha', 'Pune', 23),
(5, 'Rohit', 'Mumbai', 22),
(6, 'Pooja', 'Nagpur', 20);


-- 5. INSERT DATA INTO BOOKS

INSERT INTO books
(book_id, book_name, author, category, price)
VALUES
(101, 'SQL Basics', 'Rahul Sharma', 'Education', 500),
(102, 'Python Programming', 'Neha Gupta', 'Education', 700),
(103, 'Atomic Habits', 'James Clear', 'Self Help', 600),
(104, 'Harry Potter', 'J. K. Rowling', 'Novel', 800),
(105, 'Data Analytics', 'Amit Verma', 'Education', 900),
(106, 'The Alchemist', 'Paulo Coelho', 'Novel', 400);


-- 6. INSERT DATA INTO BORROW RECORDS

INSERT INTO borrow_records
(borrow_id, member_id, book_id, borrow_date, return_date)
VALUES
(1001, 1, 101, '2026-07-01', '2026-07-06'),
(1002, 2, 102, '2026-07-03', '2026-07-10'),
(1003, 1, 105, '2026-07-05', '2026-07-12'),
(1004, 3, 104, '2026-07-07', '2026-07-14'),
(1005, 4, 103, '2026-07-10', '2026-07-16'),
(1006, 5, 106, '2026-07-12', '2026-07-18');



-- 1. Show all books

SELECT *
FROM books;

-- 2. Show all members
SELECT *
FROM members;

-- 3. Show all borrow records

SELECT *
FROM borrow_records;


-- 4. Show only available books

SELECT *
FROM books
WHERE available_copies > 0;


-- 5. Show Education category books

SELECT *
FROM books
WHERE category = 'Education';


-- 6. Show books whose price is greater than 500

SELECT *
FROM books
WHERE price > 500;


-- 7. Sort books from highest price to lowest price

SELECT *
FROM books
ORDER BY price DESC;


-- 8. Sort books by category
-- and then book name

SELECT *
FROM books
ORDER BY category ASC, book_name ASC;


-- 9. Update the price of a book

UPDATE books
SET price = 750
WHERE book_id = 2;


-- 10. Update the city of a member

UPDATE members
SET city = 'Nagpur'
WHERE member_id = 1;


-- 11. Update book status after return

UPDATE borrow_records
SET status = 'Returned',
    return_date = CURRENT_DATE
WHERE borrow_id = 1;


-- 12. Delete a book record

DELETE FROM books
WHERE book_id = 10;

-- LIBRARY REPORTS

-- 13. Count total books

SELECT COUNT(*) AS total_books
FROM books;


-- 14. Find average book price

SELECT AVG(price) AS average_price
FROM books;


-- 15. Find highest and lowest book price

SELECT MAX(price) AS highest_price,
       MIN(price) AS lowest_price
FROM books;


-- 16. Category-wise total books

SELECT category,
       COUNT(*) AS total_books
FROM books
GROUP BY category;


-- 17. Category-wise average price

SELECT category,
       AVG(price) AS average_price
FROM books
GROUP BY category;


-- 18. Show categories having 2 or more books

SELECT category,
       COUNT(*) AS total_books
FROM books
GROUP BY category
HAVING COUNT(*) >= 2;

-- JOIN REPORTS

-- 19. Show member name and borrowed book name

SELECT members.member_name,
       books.book_name
FROM borrow_records
INNER JOIN members
ON borrow_records.member_id = members.member_id
INNER JOIN books
ON borrow_records.book_id = books.book_id;


-- 20. Show member name, book name,
-- borrow date and status

SELECT members.member_name,
       books.book_name,
       borrow_records.borrow_date,
       borrow_records.status
FROM borrow_records
INNER JOIN members
ON borrow_records.member_id = members.member_id
INNER JOIN books
ON borrow_records.book_id = books.book_id;


-- 21. Show all members,
-- even if they have not borrowed a book

SELECT members.member_name,
       books.book_name
FROM members
LEFT JOIN borrow_records
ON members.member_id = borrow_records.member_id
LEFT JOIN books
ON borrow_records.book_id = books.book_id;


-- 22. Count books borrowed by each member

SELECT members.member_name,
       COUNT(borrow_records.borrow_id) AS total_borrowed_books
FROM members
LEFT JOIN borrow_records
ON members.member_id = borrow_records.member_id
GROUP BY members.member_name;


-- 23. Show books that are currently borrowed

SELECT members.member_name,
       books.book_name,
       borrow_records.borrow_date
FROM borrow_records
INNER JOIN members
ON borrow_records.member_id = members.member_id
INNER JOIN books
ON borrow_records.book_id = books.book_id
WHERE borrow_records.status = 'Borrowed';


-- 24. Categorize books according to price

SELECT book_name,
       price,
       CASE
           WHEN price < 400 THEN 'Low Price'
           WHEN price <= 700 THEN 'Medium Price'
           ELSE 'High Price'
       END AS price_category
FROM books;


-- 25. Show books whose price is above average

SELECT book_name,
       price
FROM books
WHERE price >
(
    SELECT AVG(price)
    FROM books
);


-- 26. Show the most expensive book

SELECT book_name,
       price
FROM books
WHERE price =
(
    SELECT MAX(price)
    FROM books
);


-- 27. Create a CTE for expensive books

WITH expensive_books AS
(
    SELECT book_name,
           price
    FROM books
    WHERE price > 500
)
SELECT *
FROM expensive_books;


-- 28. Rank books according to price

SELECT book_name,
       price,
       RANK() OVER(
           ORDER BY price DESC
       ) AS price_rank
FROM books;


-- 29. Create a view for borrowing details

CREATE VIEW borrowing_details AS
SELECT members.member_name,
       books.book_name,
       borrow_records.borrow_date,
       borrow_records.return_date,
       borrow_records.status
FROM borrow_records
INNER JOIN members
ON borrow_records.member_id = members.member_id
INNER JOIN books
ON borrow_records.book_id = books.book_id;


-- 30. View the borrowing report

SELECT *
FROM borrowing_details;
