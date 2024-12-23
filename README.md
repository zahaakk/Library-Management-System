# Library-Management-System

## Project Overview

**Project Title**: Library Management System  

This project demonstrates the implementation of a Library Management System using SQL. It includes creating and managing tables, performing CRUD operations, and executing advanced SQL queries. The goal is to showcase skills in database design, manipulation, and querying.

![Library_project](https://github.com/najirh/Library-System-Management---P2/blob/main/library.jpg)

## Objectives

1. **Set up the Library Management System Database**: Create and populate the database with tables for branches, employees, members, books, issued status, and return status.
2. **CRUD Operations**: Perform Create, Read, Update, and Delete operations on the data.
3. **CTAS (Create Table As Select)**: Utilize CTAS to create new tables based on query results.

## Project Structure

### 1. Database Setup
![image](https://github.com/user-attachments/assets/d8cd963b-c0d9-4e2c-9e26-9dae75c712f0)


- **Database Creation**: Created a database named `library_management`.
- **Table Creation**: Created tables for branches, employees, members, books, issued status, and return status. Each table includes relevant columns and relationships.

```sql
create database if not exists library_management ;
use library_management ;
create table if not exists branch (
	branch_id Varchar(20) primary key,
    manager_id Varchar(20),
    branch_address Varchar(50),
    contact_no Varchar(20)
);

create table if not exists employees (
	emp_id Varchar(20) primary key ,
    emp_name Varchar(50),
    position Varchar(20),
    salary int,
    branch_id Varchar(20) # FK
) ;

create table if not exists books (
	isbn Varchar(20) primary key,
    book_title Varchar(75),
    category Varchar(20),
    rental_price Float,
    status Varchar(10),
    author Varchar(50),
    publisher Varchar(50)
) ;
			
create table if not exists members (
	member_id varchar(20) primary key,
    member_name	varchar(25),
    member_address varchar(80),
    reg_date date
) ;

create table if not exists issued_status (
	issued_id varchar(10) primary key ,
    issued_member_id varchar(10), #FK
    issued_book_name varchar(75),
    issued_date	Date ,
    issued_book_isbn varchar(25) , # FK
    issued_emp_id varchar(10) # FK
) ;

create table if not exists return_status (
	return_id varchar(10) primary key ,
    issued_id varchar(10) ,
    return_book_name varchar(75),
    return_date	Date,
    return_book_isbn varchar(20)
);

-- FOREGIN KEY
alter table issued_status
add constraint fk_members 
foreign key (issued_member_id)
References members(member_id) ;

alter table issued_status
add constraint fk_books 
foreign key (issued_book_isbn)
References books(isbn) ;

alter table issued_status
add constraint fk_employees 
foreign key (issued_emp_id)
References employees(emp_id) ;

alter table employees
add constraint fk_branch 
foreign key (branch_id)
References branch(branch_id) ;

alter table return_status
add constraint fk_issued_date
foreign key (issued_id)
references issued_status(issued_id) ;

```

### 2. CRUD Operations

- **Create**: Inserted sample records into the `books` table.
- **Read**: Retrieved and displayed data from various tables.
- **Update**: Updated records in the `employees` table.
- **Delete**: Removed records from the `members` table as needed.

**Task 1. Create a New Book Record**
-- "978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')"

```sql
insert 
into books 
	(isbn,book_title,category,rental_price,status,author,publisher)
values
	('978-1-60129-456-2', 'To Kill a Mockingbird', 
	'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')
;
```
**Task 2: Update an Existing Member's Address**

```sql
update members set member_address = '125 Main St'
where member_id = 'C101' ;
select * from members ;
```

**Task 3: Delete a Record from the Issued Status Table**
-- Objective: Delete the record with issued_id = 'IS121' from the issued_status table.

```sql
delete from issued_status 
where issued_id = 'IS121' ;
```

**Task 4: Retrieve All Books Issued by a Specific Employee**
-- Objective: Select all books issued by the employee with emp_id = 'E101'.
```sql
select * from issued_status 
where issued_emp_id = 'E101' ;
```


**Task 5: List Members Who Have Issued More Than One Book**
-- Objective: Use GROUP BY to find members who have issued more than one book.

```sql
select issued_emp_id,count(*) as book_issued
from issued_status 
group by issued_emp_id 
having count(*) > 1;
```

### 3. CTAS (Create Table As Select)

- **Task 6: Create Summary Tables**: Used CTAS to generate new tables based on query results - each book and total book_issued_cnt**

```sql
create table book_cnts 
as
SELECT b.isbn, b.book_title, COUNT(ist.issued_id) AS issue_count
FROM issued_status as ist
JOIN books as b
ON ist.issued_book_isbn = b.isbn
GROUP BY b.isbn, b.book_title;
```


### 4. Data Analysis & Findings

The following SQL queries were used to address specific questions:

Task 7. **Retrieve All Books in a Specific Category**:

```sql
select * from books 
where category = 'horror' ;
```

8. **Task 8: Find Total Rental Income by Category**:

```sql
select 
	category,sum(rental_price) as Rental_income,count(*) as book_sold
from issued_status s
left join books b
on s.issued_book_isbn = b.isbn 
group by category ;  
```

9. **List Members Who Registered in the Last 180 Days**:
```sql
update members set reg_date= '2024-12-15'
where member_id = 'C118';

update members set reg_date= '2024-12-12'
where member_id = 'C119';

select * from members
where reg_date >= current_date - interval 180 day ;
```

10. **List Employees with Their Branch Manager's Name and their branch details**:

```sql
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
```

Task 11. **Create a Table of Books with Rental Price Above a Certain Threshold**:
```sql
create table expansive_books as
select * from books 
where rental_price > 7 ;
```

Task 12: **Retrieve the List of Books Not Yet Returned**
```sql
select distinct ist.issued_book_name from return_status rs
right join issued_status ist
using (issued_id) 
WHERE rs.return_id IS NULL ;
```

**Task 13: Identify Members with Overdue Books**  
Write a query to identify members who have overdue books (assume a 30-day return period). Display the member's_id, member's name, book title, issue date, and days overdue.

```sql
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
```
## Conclusion

This project demonstrates the application of SQL skills in creating and managing a library management system. It includes database setup, data manipulation, and advanced querying, providing a solid foundation for data management and analysis.
