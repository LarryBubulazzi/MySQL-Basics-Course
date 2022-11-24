CREATE DATABASE ruk_database;

CREATE TABLE branches(
id INT PRIMARY KEY AUTO_INCREMENT,
name VARCHAR(30) UNIQUE NOT NULL
);

CREATE TABLE employees(
id INT PRIMARY KEY AUTO_INCREMENT,
first_name VARCHAR(20) NOT NULL,
last_name VARCHAR(20) NOT NULL,
salary DECIMAL(10,2) NOT NULL,
started_on DATE NOT NULL,
branch_id INT NOT NULL
);

CREATE TABLE clients(
id INT PRIMARY KEY AUTO_INCREMENT,
full_name VARCHAR(50) NOT NULL,
age INT NOT NULL
);

CREATE TABLE employees_clients(
employee_id INT,
client_id INT
);

CREATE TABLE bank_accounts(
id INT PRIMARY KEY AUTO_INCREMENT,
account_number VARCHAR(10) NOT NULL,
balance DECIMAL(10,2) NOT NULL,
client_id INT UNIQUE NOT NULL
);

CREATE TABLE cards(
id INT PRIMARY KEY AUTO_INCREMENT,
card_number VARCHAR(19) NOT NULL,
card_status VARCHAR(7) NOT NULL,
bank_account_id INT NOT NULL
);

ALTER TABLE employees
ADD CONSTRAINT fk_employees_branches
FOREIGN KEY (branch_id)
REFERENCES branches(id);

ALTER TABLE employees_clients
ADD CONSTRAINT fk_employees_clients_employees
FOREIGN KEY (employee_id)
REFERENCES employees(id);

ALTER TABLE employees_clients
ADD CONSTRAINT fk_employees_clients_clients
FOREIGN KEY (client_id)
REFERENCES clients(id);

ALTER TABLE bank_accounts
ADD CONSTRAINT fk_bank_accounts_clients
FOREIGN KEY (client_id)
REFERENCES clients(id);

ALTER TABLE cards
ADD CONSTRAINT fk_cards_bank_accounts
FOREIGN KEY (bank_account_id)
REFERENCES bank_accounts(id);

/* 02. Insert
You will have to insert records of data into the cards table, based on the clients table. 
For clients with id between 191 and 200 (inclusive), insert data in the cards table with the following values:
•	card_number – set it to full name of the client, but reversed!
•	card_status – set it to "Active".
•	bank_account_id –set it to client's id value. 
*/
INSERT INTO cards(card_number, card_status, bank_account_id)
SELECT REVERSE(cl.full_name), 'Active', cl.id
 FROM cards as c
 JOIN bank_accounts as ba
 ON ba.id = c.id
 JOIN clients as cl
 ON cl.id = ba.client_id
 WHERE cl.id BETWEEN 191 AND 200;
 
#второ решение 
INSERT INTO cards(card_number, card_status, bank_account_id)
SELECT REVERSE(full_name), 'Active', id
FROM clients
WHERE id BETWEEN 191 AND 200;

/*03.	Update
Update all clients which have the same id as the employee they are appointed to. 
Set their employee_id with the employee with the lowest count of clients.
If there are 2 such employees with equal count of clients, take the one with the lowest id.
*/

UPDATE clients as c
SET ec.employee_id = (SELECT MIN(COUNT(ec.employee_id)) FROM employees_clients as ec
WHERE ec.employee_id = ec.client_id);


/* 04.Delete
R.U.K. Bank is a sophisticated network. As such, it cannot allow procrastination and lazy behavior. 
Delete all employees which do not have any clients. 
*/

DELETE
FROM employees as e 
WHERE id NOT IN (SELECT ec.employee_id from employees_clients as ec);

/* 05. Clients
Extract from the database, all of the clients. 
Order the results ascending by client id.
Required Columns
•	id (clients)
•	full_name
*/

SELECT id, full_name
FROM clients
ORDER BY id;

/* 06. Newbies
One of your bosses has requested a functionality which checks the newly employed – highly paid people.
Extract from the database, all of the employees, which have salary greater than or equal to 100000 
and have started later than or equal to the 1st of January - 2018. 
The salary should have a "$" as a prefix.
Order the results descending by salary, then by id.
•	id (employees)
•	full_name (first_name + " " + last_name)
•	salary
•	started_on
*/

SELECT id, CONCAT(first_name, ' ', last_name) as 'full_name', CONCAT('$', salary) as 'salary', started_on
FROM employees
WHERE salary >= 100000 AND YEAR(started_on) >= '01-01-2018'
ORDER BY salary DESC, id ASC;

/* 07. Cards against Humanity
Extract from the database, all of the cards, and the clients that own them, so that they end up in the following format:
{card_number} : {full_name}
Order the results descending by card id.
Required Columns
•	id (cards)
•	card_token
*/

SELECT card.id, CONCAT(card.card_number, ' : ', c.full_name) AS 'card_token'
FROM cards as card
JOIN bank_accounts as b
ON card.bank_account_id = b.id
JOIN clients as c
ON c.id = b.client_id
ORDER BY card.id DESC;

/* 08. Top 5 Employees
Extract from the database, the top 5 employees, in terms of clients assigned to them.
Order the results descending by count of clients, and ascending by employee id.
Required Columns
•	name (employees)
•	started_on
•	count_of_clients
*/

SELECT CONCAT(e.first_name, ' ', e.last_name) as 'name', e.started_on, COUNT(ec.client_id) AS 'count_of_clients'
FROM employees as e
JOIN employees_clients as ec
ON e.id = ec.employee_id
GROUP BY e.id
ORDER BY count_of_clients DESC, e.id
LIMIT 5;

/* 09. Branch cards
Extract from the database, all branches with the count of their issued cards. Order the results by the count of cards, then by branch name.
Required Columns
•	name (branch)
•	count_of_cards
*/

SELECT b.name, COUNT(card.id) AS count_of_cards
FROM branches as b
LEFT JOIN employees as e
ON b.id = e.branch_id
LEFT JOIN employees_clients as ec
ON e.id = ec.employee_id
LEFT JOIN clients as cl
ON cl.id = ec.client_id
LEFT JOIN bank_accounts as ba
ON ba.client_id = cl.id
LEFT JOIN cards as card
ON card.bank_account_id = ba.id
GROUP BY b.id
ORDER BY count_of_cards DESC, b.name;

/* 10. Extract client cards count
Create a user defined function with the name udf_client_cards_count(name VARCHAR(30)) that receives a client's full name and returns the number of cards he has.
Required Columns
•	full_name (clients)
•	cards (count of cards)
*/

DELIMITER $$
CREATE FUNCTION udf_client_cards_count(name VARCHAR(30))
RETURNS INT
DETERMINISTIC
BEGIN
DECLARE cards_count INT;
SET cards_count :=(SELECT COUNT(c.id) as 'cards'
 FROM clients as cl
 JOIN bank_accounts as ba
 ON ba.client_id = cl.id
 JOIN cards as c
 ON c.bank_account_id = ba.id
 WHERE cl.full_name = name);
RETURN cards_count;
END $$

CALL udf_client_cards_count('Baxy David');

/* 11. Extract Client Info
Create a stored procedure udp_clientinfo which accepts the following parameters:
•	full_name
And extracts data about the client with the given full name.
Aside from the full_name, the procedure should extract the client's age, bank account number and balance.
The account’s salary should have "$" prefix.
*/
DELIMITER $$
CREATE PROCEDURE udp_clientinfo(full_name VARCHAR(50))
BEGIN
SELECT cl.full_name, cl.age, ba.account_number, CONCAT('$',ba.balance) as 'balance'
FROM clients as cl
JOIN bank_accounts as ba
ON ba.client_id = cl.id
WHERE cl.full_name = full_name;
END $$

CALL udp_clientinfo('Hunter Wesgate');
