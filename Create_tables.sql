--customers table

create table customers(
customer_id number primary key,
name varchar2(100));


--loans table

create table loans(
loan_id number primary key,
customer_id number,
loan_amount number,
interest_rate number,
start_date date,
due_date date,
status varchar2(20),
foreign key (customer_id) references customers(customer_id));



--loan payments table

create table loan_payments(
payment_id number primary key,
loan_id number,
payment_date date,
payment_amount number,
foreign key (loan_id) references loans(loan_id));
