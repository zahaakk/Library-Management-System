select * from books ;
select * from branch ;
select * from employees ;
select * from issued_status ;
select * from members ;
select * from return_status ;

-- Project TASK --
# Task 1. Create a New Book Record -- "978-1-60129-456-2', 'To Kill a Mockingbird', 
				  # 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')"

insert 
into books 
	(isbn,book_title,category,rental_price,status,author,publisher)
values
	('978-1-60129-456-2', 'To Kill a Mockingbird', 
	'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')
;
#Task 2: Update an Existing Member's Address
update members set member_address = '125 Main St'
where member_id = 'C101' ;
select * from members ;

# Task 3: Delete a Record from the Issued Status Table 
-- Objective: Delete the record with issued_id = 'IS121' from the issued_status table.

delete from issued_status 
where issued_id = 'IS121' ;

select * from issued_status ;

# Task 4: Retrieve All Books Issued by a Specific Employee -- 
-- Objective: Select all books issued by the employee with emp_id = 'E101'.

select * from issued_status 
where issued_emp_id = 'E101' ;

# Task 5: List Members Who Have Issued More Than One Book 
-- Objective: Use GROUP BY to find members who have issued more than one book.

select issued_emp_id,count(*) as book_issued
from issued_status 
group by issued_emp_id 
having count(*) > 1;

-- Task 6: Create Summary Tables: Used CTAS to generate new tables based on query results 
-- each book and total book_issued_cnt**

create table book_cnts 
as
SELECT b.isbn, b.book_title, COUNT(ist.issued_id) AS issue_count
FROM issued_status as ist
JOIN books as b
ON ist.issued_book_isbn = b.isbn
GROUP BY b.isbn, b.book_title;

-- Task 7. Retrieve All Books in a Specific Category:
select * from books 
where category = 'horror' ;

-- Task 8: Find Total Rental Income by Category:
select 
	category,sum(rental_price) as Rental_income,count(*) as book_sold
from issued_status s
left join books b
on s.issued_book_isbn = b.isbn 
group by category ;

-- Task 9: List Members Who Registered in the Last 180 Days:
update members set reg_date= '2024-12-15'
where member_id = 'C118';

update members set reg_date= '2024-12-12'
where member_id = 'C119';

select * from members
where reg_date >= current_date - interval 180 day ;

-- Task 10: List Employees with Their Branch Manager's Name and their branch details:
select * from branch ;
select * from employees ;

select 
	e.branch_id,
    e.emp_id,
    e.emp_name,
    e.position,
    e2.emp_name as Manger,
    e.salary,
    b.manager_id,
    b.contact_no
from employees e
join branch b
using (branch_id) 
join employees e2
on b.manager_id=e2.emp_id;

-- Task 11. Create a Table of Books with Rental Price Above a Certain Threshold:
create table expansive_books as
select * from books 
where rental_price > 7 ;

-- Task 12: Retrieve the List of Books Not Yet Returned
select * from return_status ;
select * from issued_status ;

select distinct ist.issued_book_name from return_status rs
right join issued_status ist
using (issued_id) 
WHERE rs.return_id IS NULL ;

/*
Task 13: Identify Members with Overdue Books
Write a query to identify members who have overdue books (assume a 30-day return period). 
Display the member's_id, member's name, book title, issue date, and days overdue.
*/
-- issued status == members == books == return_status
-- filter books which is not return 
-- overdue > 30

select 
	issued_member_id,
    member_name,
    book_title,
    issued_date,
    return_date,
    current_date()-issued_date as over_due_days
from issued_status ish
join members m
on ish.issued_member_id= m.member_id 
join books  b
on b.isbn = ish.issued_book_isbn
left join return_status rs
on rs.issued_id = ish.issued_id 
where return_date is null ;
