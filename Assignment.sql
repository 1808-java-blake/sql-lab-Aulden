-- Setting up Oracle Chinook
-- In this section you will begin the process of working with the Oracle Chinook database

-- Task – Open the Chinook_Oracle.sql file and execute the scripts within.

-- 2.0 SQL Queries
-- In this section you will be performing various queries against the Oracle Chinook database.

-- 2.1 SELECT
-- Task – Select all records from the Employee table.
SELECT * FROM EMPLOYEE;
-- Task – Select all records from the Employee table where last name is King.
SELECT * FROM EMPLOYEE WHERE lastname = 'King';
-- Task – Select all records from the Employee table where first name is Andrew and REPORTSTO is NULL.
SELECT * FROM EMPLOYEE WHERE firstname = 'Andrew' AND reportsto is NULL;

-- 2.2 ORDER BY
-- Task – Select all albums in Album table and sort result set in descending order by title.
SELECT * FROM ALBUM ORDER BY title DESC;
-- Task – Select first name from Customer and sort result set in ascending order by city
SELECT firstname FROM CUSTOMER ORDER BY city ASC;

-- 2.3 INSERT INTO
-- Task – Insert two new records into Genre table
INSERT INTO GENRE (genreid, name) VALUES (56506, 'Heavy Bass'), (4444, 'Slow Jazz');
-- Task – Insert two new records into Employee table
INSERT INTO EMPLOYEE VALUES (9, 'Marley', 'Bob', 'Bossman', 3, '1984-01-01', '1983-01-01', 'Bob Lane', 'Washington', 'MO', 'China', '64712', '867-5309', '867-5309', 'john.smith@smithy.com'), (10, 'Smith', 'John', 'Average Joe', 1, '1984-01-01', '1983-01-01', 'Bob Lane', 'Washington', 'MO', 'China', '64712', '867-5309', '867-5309', 'john.smith@smithy.com');
-- Task – Insert two new records into Customer table
INSERT INTO CUSTOMER VALUES (60, 'bob', 'farman', 'Google', '852 West Lane', 'Venice', 'RM', 'Italy', '545', '587-4564', '454-5656', 4), (61, 'joe', 'farman', 'Google', '852 West Lane', 'Venice', 'RM', 'Italy', '545', '587-4564', '454-5656', 4);

-- 2.4 UPDATE
-- Task – Update Aaron Mitchell in Customer table to Robert Walter
UPDATE CUSTOMER SET firstname = 'Robert', lastname = 'Walter' WHERE firstname = 'Aaron' AND lastname = 'Mitchell';
-- Task – Update name of artist in the Artist table “Creedence Clearwater Revival” to “CCR”
UPDATE ARTIST SET name = 'CCR' WHERE name = 'Creedence Clearwater Revival';

-- 2.5 LIKE
-- Task – Select all invoices with a billing address like “T%”
SELECT * FROM INVOICE WHERE billingaddress LIKE 'T%';

-- 2.6 BETWEEN
-- Task – Select all invoices that have a total between 15 and 50
SELECT * FROM INVOICE WHERE total BETWEEN 15 AND 50;
-- Task – Select all employees hired between 1st of June 2003 and 1st of March 2004
SELECT * FROM EMPLOYEE WHERE hiredate BETWEEN '2003-06-01' AND '2004-03-01'; 

-- 2.7 DELETE
-- Task – Delete a record in Customer table where the name is Robert Walter (There may be constraints that rely on this, find out how to resolve them).
-- NOTE: This is a terrible way to handle it, if I was making the tables I'd
-- use Cascading Delete
DELETE FROM INVOICELINE WHERE invoiceid IN (SELECT invoiceid FROM INVOICE WHERE customerid IN (SELECT customerid FROM CUSTOMER WHERE firstname = 'Robert' AND lastname = 'Walter'));
DELETE FROM INVOICE WHERE customerid IN (SELECT customerid FROM CUSTOMER WHERE firstname = 'Robert' AND lastname = 'Walter');
DELETE FROM CUSTOMER WHERE firstname = 'Robert' AND lastname = 'Walter';

-- SQL Functions
-- In this section you will be using the Oracle system functions, as well as your own functions, to perform various actions against the database
-- 3.1 System Defined Functions
-- Task – Create a function that returns the current time.
CREATE FUNCTION curTime ()
RETURNS TIME AS $t$
    DECLARE
        t TIME;
    BEGIN
        SELECT CURRENT_TIME INTO t;
        RETURN t;
    END;
    $t$ LANGUAGE PLPGSQL;
-- Task – create a function that returns the length of a mediatype from the mediatype table
CREATE FUNCTION mediaLen (media VARCHAR)
RETURNS INTEGER AS $leng$
    DECLARE
        leng INTEGER;
    BEGIN
        SELECT LENGTH(media) INTO leng;
        RETURN leng;
    END;
    $leng$ LANGUAGE PLPGSQL;

-- 3.2 System Defined Aggregate Functions
-- Task – Create a function that returns the average total of all invoices
CREATE FUNCTION AVER ()
    RETURNS NUMERIC(10, 2) AS $av$
        DECLARE
            av NUMERIC(10, 2);
        BEGIN
            SELECT AVG(total) FROM invoice INTO av;
            RETURN av;
        END;
        $av$ LANGUAGE PLPGSQL;

-- Task – Create a function that returns the most expensive track
CREATE FUNCTION MAXTRACK ()
    RETURNS NUMERIC(10, 2) AS $MA$
        DECLARE
            MA NUMERIC(10, 2);
        BEGIN
            SELECT MAX(unitprice) FROM track INTO MA;
            RETURN MA;
        END;
        $MA$ LANGUAGE PLPGSQL;

-- 3.3 User Defined Scalar Functions
-- Task – Create a function that returns the average price of invoiceline items in the invoiceline table
CREATE FUNCTION AVERS ()
    RETURNS NUMERIC(10, 2) AS $av$
        DECLARE
            av NUMERIC(10, 2);
        BEGIN
            SELECT AVG(unitprice) FROM invoiceline INTO av;
            RETURN av;
        END;
        $av$ LANGUAGE PLPGSQL;

-- 3.4 User Defined Table Valued Functions
-- Task – Create a function that returns all employees who are born after 1968.
CREATE FUNCTION OLD ()
    RETURNS TABLE (
        name VARCHAR,
        bday TIMESTAMP
    )
    AS $v$
        BEGIN
            RETURN QUERY SELECT firstname, birthdate FROM employee WHERE birthdate > '1968-12-31';
        END;
        $v$ LANGUAGE PLPGSQL;

-- 4.0 Stored Procedures
--  In this section you will be creating and executing stored procedures. You will be creating various types of stored procedures that take input and output parameters.
-- 4.1 Basic Stored Procedure
-- Task – Create a stored procedure that selects the first and last names of all the employees.
-- 4.2 Stored Procedure Input Parameters
-- Task – Create a stored procedure that updates the personal information of an employee.
-- Task – Create a stored procedure that returns the managers of an employee.
-- 4.3 Stored Procedure Output Parameters
-- Task – Create a stored procedure that returns the name and company of a customer.
-- 5.0 Transactions
-- In this section you will be working with transactions. Transactions are usually nested within a stored procedure. You will also be working with handling errors in your SQL.
-- Task – Create a transaction that given a invoiceId will delete that invoice (There may be constraints that rely on this, find out how to resolve them).
-- Task – Create a transaction nested within a stored procedure that inserts a new record in the Customer table
-- 6.0 Triggers
-- In this section you will create various kinds of triggers that work when certain DML statements are executed on a table.
-- 6.1 AFTER/FOR
-- Task - Create an after insert trigger on the employee table fired after a new record is inserted into the table.
-- Task – Create an after update trigger on the album table that fires after a row is inserted in the table
-- Task – Create an after delete trigger on the customer table that fires after a row is deleted from the table.

-- 6.2 INSTEAD OF
-- Task – Create an instead of trigger that restricts the deletion of any invoice that is priced over 50 dollars.
-- 7.0 JOINS
-- In this section you will be working with combing various tables through the use of joins. You will work with outer, inner, right, left, cross, and self joins.
-- 7.1 INNER
-- Task – Create an inner join that joins customers and orders and specifies the name of the customer and the invoiceId.
SELECT customer.firstname, invoice.invoiceid FROM customer INNER JOIN invoice ON customer.customerid = invoice.customerid;

-- 7.2 OUTER
-- Task – Create an outer join that joins the customer and invoice table, specifying the CustomerId, firstname, lastname, invoiceId, and total.
SELECT customer.customerid, customer.firstname, customer.lastname, invoice.invoiceid, invoice.total FROM customer FULL JOIN invoice ON customer.customerid = invoice.customerid;

-- 7.3 RIGHT
-- Task – Create a right join that joins album and artist specifying artist name and title.
SELECT artist.name, album.title FROM artist RIGHT JOIN album ON artist.artistid = album.artistid; 

-- 7.4 CROSS
-- Task – Create a cross join that joins album and artist and sorts by artist name in ascending order.
SELECT * FROM album CROSS JOIN artist ORDER BY artist.name ASC;

-- 7.5 SELF
-- Task – Perform a self-join on the employee table, joining on the reportsto column.
-- Output isn't good looking but wasn't sure if it just wanted names or not
SELECT * FROM employee AS A INNER JOIN employee AS B ON A.reportsto = B.employeeid;