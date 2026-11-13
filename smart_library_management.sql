
DROP DATABASE IF EXISTS smart_library;
CREATE DATABASE smart_library;
USE smart_library;

CREATE TABLE books (
    book_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(150) NOT NULL,
    author VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL,
    copies INT NOT NULL DEFAULT 1
);

CREATE TABLE members (
    member_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(15)
);


CREATE TABLE borrowings (
    borrowing_id INT AUTO_INCREMENT PRIMARY KEY,
    book_id INT NOT NULL,
    member_id INT NOT NULL,
    borrowed_on DATE NOT NULL,
    due_on DATE NOT NULL,
    returned_on DATE,
    FOREIGN KEY (book_id) REFERENCES books(book_id),
    FOREIGN KEY (member_id) REFERENCES members(member_id)
);

CREATE TABLE fines (
    fine_id INT AUTO_INCREMENT PRIMARY KEY,
    borrowing_id INT NOT NULL,
    amount DECIMAL(8,2) NOT NULL,
    paid BOOLEAN NOT NULL DEFAULT FALSE,
    FOREIGN KEY (borrowing_id) REFERENCES borrowings(borrowing_id)
);


INSERT INTO books (title, author, category, copies) VALUES
('Five Point Someone', 'Chetan Bhagat', 'Fiction', 4),
('Database System Concepts', 'Abraham Silberschatz', 'Database', 3),
('Harry Potter and the Stone', 'J. K. Rowling', 'Fantasy', 4),
('The C Programming Language', 'Dennis Ritchie', 'Programming', 3),
('Let Us C', 'Yashavant Kanetkar', 'Programming', 5),
('Malgudi Days', 'R. K. Narayan', 'Fiction', 3),
('Wings of Fire', 'A. P. J. Abdul Kalam', 'Biography', 3),
('1984', 'George Orwell', 'Fiction', 3);

INSERT INTO members (name, email, phone) VALUES
('Akashdeep Singh', 'akashdeep@cuchd.in', '9876500001'),
('Aman Verma', 'aman@cuchd.in', '9876500002'),
('Riya Sharma', 'riya@cuchd.in', '9876500003'),
('Simran Kaur', 'simran@cuchd.in', '9876500005');

INSERT INTO borrowings (book_id, member_id, borrowed_on, due_on, returned_on) VALUES
(1, 1, '2026-09-01', '2026-09-15', '2026-09-14'),
(2, 2, '2026-09-03', '2026-09-17', '2026-09-25'),
(3, 3, '2026-09-05', '2026-09-19', '2026-09-18'),
(4, 1, '2026-09-20', '2026-10-04', NULL);

INSERT INTO fines (borrowing_id, amount, paid)
VALUES (2, 40.00, TRUE);

SELECT * FROM books;

SELECT * FROM members;

SELECT m.name, b.title, br.borrowed_on, br.due_on
FROM borrowings br
JOIN members m ON m.member_id = br.member_id
JOIN books b ON b.book_id = br.book_id
WHERE br.returned_on IS NULL;

SELECT m.name, b.title, br.due_on
FROM borrowings br
JOIN members m ON m.member_id = br.member_id
JOIN books b ON b.book_id = br.book_id
WHERE br.returned_on IS NULL AND br.due_on < CURDATE();

SELECT m.name, b.title, f.amount
FROM fines f
JOIN borrowings br ON br.borrowing_id = f.borrowing_id
JOIN members m ON m.member_id = br.member_id
JOIN books b ON b.book_id = br.book_id
WHERE f.paid = FALSE;

-- Borrow a book:
-- INSERT INTO borrowings (book_id, member_id, borrowed_on, due_on)
-- VALUES (1, 2, CURDATE(), DATE_ADD(CURDATE(), INTERVAL 14 DAY));

-- Return a book:
-- UPDATE borrowings SET returned_on = CURDATE()
-- WHERE borrowing_id = 1;
