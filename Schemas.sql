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