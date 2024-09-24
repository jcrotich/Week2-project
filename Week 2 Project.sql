CREATE TABLE Authors (
    author_id INT PRIMARY KEY,
    name VARCHAR(100),
    birth_date DATE
);

CREATE TABLE Books (
    book_id INT PRIMARY KEY,
    title VARCHAR(255),
    author_id INT,
    published_date DATE,
    price DECIMAL(10, 2),
    stock INT,
    FOREIGN KEY (author_id) REFERENCES Authors(author_id)
);

CREATE TABLE Customerz (
    customer_id INT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100)
);


CREATE TABLE Orderz (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    FOREIGN KEY (customer_id) REFERENCES Customerz(customer_id)
);

CREATE TABLE Order_Details (
    order_detail_id INT PRIMARY KEY,
    order_id INT,
    book_id INT,
    quantity INT,
    FOREIGN KEY (order_id) REFERENCES Orderz(order_id),
    FOREIGN KEY (book_id) REFERENCES Books(book_id)
);



INSERT INTO Authors (author_id, name, birth_date) VALUES
(1, 'John Smith', '1975-06-12'),
(2, 'Jane Doe', '1980-02-23'),
(3, 'Alice Johnson', '1990-11-05'),
(4, 'Bob Brown', '1985-07-30');

INSERT INTO Books (book_id, title, author_id, published_date, price, stock) VALUES
(1, 'Learning SQL', 1, '2020-01-15', 29.99, 100),
(2, 'Data Science with Python', 2, '2021-03-10', 39.99, 50),
(3, 'Advanced SQL Queries', 1, '2019-06-20', 49.99, 75),
(4, 'Introduction to Machine Learning', 3, '2022-05-25', 34.99, 40),
(5, 'Web Development Basics', 4, '2018-08-30', 24.99, 80);

INSERT INTO Customerz (customer_id, name, email) VALUES
(1, 'Emily Carter', 'emily.carter@example.com'),
(2, 'Michael Lee', 'michael.lee@example.com'),
(3, 'Sarah Wilson', 'sarah.wilson@example.com'),
(4, 'David Kim', 'david.kim@example.com');

INSERT INTO Orderz (order_id, customer_id, order_date) VALUES
(1, 1, '2024-01-10'),
(2, 2, '2024-01-15'),
(3, 3, '2024-01-20'),
(4, 1, '2024-01-25');

INSERT INTO Order_Details (order_detail_id, order_id, book_id, quantity) VALUES
(1, 1, 1, 1),
(2, 1, 3, 2),
(3, 2, 2, 1),
(4, 3, 4, 1),
(5, 4, 5, 3);


SELECT * FROM Authors
WHERE name LIKE 'J%';

SELECT title AS name FROM Books
UNION
SELECT name FROM Authors;


SELECT c.name AS customer_name, o.order_id, b.title AS book_title
FROM Customerz c
INNER JOIN Orderz o ON c.customer_id = o.customer_id
INNER JOIN Order_Details od ON o.order_id = od.order_id
INNER JOIN Books b ON od.book_id = b.book_id;


SELECT c.name AS customer_name, o.order_id, b.title AS book_title
FROM Customerz c
LEFT JOIN Orderz o ON c.customer_id = o.customer_id
LEFT JOIN Order_Details od ON o.order_id = od.order_id
LEFT JOIN Books b ON od.book_id = b.book_id;

SELECT o.order_id, c.name AS customer_name, b.title AS book_title
FROM Orderz o
RIGHT JOIN Customerz c ON o.customer_id = c.customer_id
RIGHT JOIN Order_Details od ON o.order_id = od.order_id
RIGHT JOIN Books b ON od.book_id = b.book_id;

SELECT DISTINCT c.name
FROM Customerz c
WHERE c.customer_id IN (
    SELECT o.customer_id
    FROM Orderz o
    JOIN Order_Details od ON o.order_id = od.order_id
    JOIN Books b ON od.book_id = b.book_id
    JOIN Authors a ON b.author_id = a.author_id
    WHERE a.name = 'John Smith'
);

DELIMITER //

CREATE TRIGGER UpdateStockAfterOrder
AFTER INSERT ON Order_Details
FOR EACH ROW
BEGIN
    UPDATE Books
    SET stock = stock - NEW.quantity
    WHERE book_id = NEW.book_id;
END //

DELIMITER ;