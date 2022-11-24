/* 1. Count Employees by Town
Write a function ufn_count_employees_by_town(town_name) 
that accepts town_name as parameter and returns the count of employees who live in that town. 
*/

DELIMITER $$
CREATE FUNCTION ufn_count_employees_by_town(town_name VARCHAR(20))
RETURNS DOUBLE
BEGIN
DECLARE e_count DOUBLE;
SET e_count := (SELECT count(employee_id)
FROM employees as e
JOIN addresses as a
ON e.address_id = a.address_id
JOIN towns as t 
ON t.town_id = a.town_id
WHERE t.name = town_name);
RETURN e_count;
END;

/* 1. Employees with Salary Above 35000
Create stored procedure usp_get_employees_salary_above_35000 that returns all employees’ first and last names for whose salary
is above 35000. The result should be sorted by first_name then by last_name alphabetically, and id ascending. 
*/
DELIMITER $$
CREATE PROCEDURE usp_get_employees_salary_above_35000 ()
BEGIN
SELECT first_name, last_name 
FROM employees
WHERE salary > 35000
ORDER BY first_name, last_name, employee_id;
END $$

/* 2. Employees with Salary Above Number
Create stored procedure usp_get_employees_salary_above that accept a number as parameter and return all employees’ 
first and last names whose salary is above or equal to the given number.
 The result should be sorted by first_name then by last_name alphabetically and id ascending.
*/

DELIMITER $$
CREATE PROCEDURE usp_get_employees_salary_above(given_number double(19,4))
BEGIN
SELECT first_name, last_name 
FROM employees
WHERE salary >= given_number
ORDER BY first_name, last_name, employee_id; 
END $$;

/*3. Town Names Starting With
Write a stored procedure usp_get_towns_starting_with that accept string as parameter and returns all town names 
starting with that string. The result should be sorted by town_name alphabetically. 
*/

DELIMITER $$
CREATE PROCEDURE usp_get_towns_starting_with(town_name_start VARCHAR(30))
BEGIN
SELECT name AS 'town_name'
FROM towns
WHERE name LIKE CONCAT(town_name_start , '%' )
ORDER BY name;
END $$

/* 4.	Employees from Town
Write a stored procedure usp_get_employees_from_town that accepts town_name as parameter and return the employees’ first and 
last name that live in the given town. The result should be sorted by first_name then by last_name alphabetically 
and id ascending. 
*/
DELIMITER $$

CREATE PROCEDURE usp_get_employees_from_town(town_name VARCHAR(30))
BEGIN
SELECT e.first_name, e.last_name 
FROM employees as e
JOIN addresses as a
ON a.address_id = e.address_id
JOIN towns as t
ON a.town_id = t.town_id
WHERE t.name = town_name
ORDER BY e.first_name, e.last_name, e.employee_id;
END $$

/* 5. Salary Level Function
Write a function ufn_get_salary_level that receives salary of an employee and returns the level of the salary.
•	If salary is < 30000 return “Low”
•	If salary is between 30000 and 50000 (inclusive) return “Average”
•	If salary is > 50000 return “High”
*/

DELIMITER $$
CREATE FUNCTION ufn_get_salary_level(employee_salary DECIMAL(19,4))
RETURNS VARCHAR(10)
DETERMINISTIC
BEGIN
DECLARE level_salary VARCHAR(10);

IF employee_salary < 30000 THEN SET level_salary := 'Low';
ELSEIF employee_salary BETWEEN 30000 AND 50000 THEN SET level_salary := 'Average';
ELSE SET level_salary := 'High';
END IF;
RETURN level_salary;

END $$

/*6.	Employees by Salary Level
Write a stored procedure usp_get_employees_by_salary_level that receive as parameter level of salary (low, average or high)
 and print the names of all employees that have given level of salary.
 The result should be sorted by first_name then by last_name both in descending order.
*/
DELIMITER $$
CREATE PROCEDURE usp_get_employees_by_salary_level(level_salary VARCHAR(10))
BEGIN
SELECT first_name, last_name 
FROM employees 
WHERE LOWER(ufn_get_salary_level(salary)) = level_salary
ORDER BY first_name DESC, last_name DESC;
END $$

CALL usp_get_employees_by_salary_level('high');

#07. Define Function
CREATE FUNCTION ufn_is_word_comprised(set_of_letters varchar(50), word varchar(50))
RETURNS BIT
RETURN word REGEXP (concat('^[', set_of_letters, ']+$'));


#08. Find Full Name
DELIMITER $$
CREATE PROCEDURE usp_get_holders_full_name()
BEGIN
 SELECT CONCAT(first_name, ' ', last_name) AS full_name
FROM account_holders
ORDER BY full_name, id;
END $$

#09. People with Balance Higher Than
DELIMITER $$
CREATE PROCEDURE usp_get_holders_with_balance_higher_than(salary_level DECIMAL)
BEGIN
SELECT ah.first_name, ah.last_name
FROM account_holders AS ah
JOIN accounts as a
ON a.account_holder_id = ah.id
GROUP BY a.account_holder_id
HAVING SUM(balance) > salary_level
ORDER BY a.id;
END $$

#10. Future Value Function
DELIMITER $$
CREATE FUNCTION ufn_calculate_future_value(
    initial_sum DECIMAL(19, 4), interest_rate DECIMAL(19, 4), years INT)
RETURNS DOUBLE(19, 2) 
BEGIN
    RETURN initial_sum * POW((1 + interest_rate), years);
END $$

#11. Calculating Interest
DELIMITER $$
CREATE PROCEDURE `usp_calculate_future_value_for_account`
	(`account_id` INT, `interest_rate` DECIMAL(20,4))
BEGIN
	SELECT a.`id`, h.`first_name`, h.`last_name`, a.`balance`,
		ufn_calculate_future_value(a.`balance`, interest_rate, 5) AS `balance_in_5_years`
	FROM `account_holders` AS `h`
    JOIN `accounts` `a` ON `a`.`account_holder_id` = `h`.`id`
	WHERE a.`id` = `account_id`
    GROUP BY a.`account_holder_id`;
END $$

CALL usp_calculate_future_value_for_account(1, 0.1);

#12. Deposit Money
DELIMITER $$
CREATE PROCEDURE usp_deposit_money(
    account_id INT, money_amount DECIMAL(19, 4))
BEGIN
    IF money_amount > 0 THEN
        START TRANSACTION;
        
        UPDATE `accounts` AS a 
        SET 
            a.balance = a.balance + money_amount
        WHERE
            a.id = account_id;
        
        IF (SELECT a.balance 
            FROM `accounts` AS a 
            WHERE a.id = account_id) < 0
            THEN ROLLBACK;
        ELSE
            COMMIT;
        END IF;
    END IF;
END $$

#13. Withdraw Money
DELIMITER $$
CREATE PROCEDURE usp_withdraw_money(
    account_id INT, money_amount DECIMAL(19, 4))
BEGIN
    IF money_amount > 0 THEN
        START TRANSACTION;
        
        UPDATE `accounts` AS a 
        SET 
            a.balance = a.balance - money_amount
        WHERE
            a.id = account_id;
        
        IF (SELECT a.balance 
            FROM `accounts` AS a 
            WHERE a.id = account_id) < 0
            THEN ROLLBACK;
        ELSE
            COMMIT;
        END IF;
    END IF;
END $$

#14.	Money Transfer
DELIMITER $$
CREATE PROCEDURE usp_transfer_money(
    from_account_id INT, to_account_id INT, money_amount DECIMAL(19, 4))
BEGIN
    IF money_amount > 0 
        AND from_account_id <> to_account_id 
        AND (SELECT a.id 
            FROM `accounts` AS a 
            WHERE a.id = to_account_id) IS NOT NULL
        AND (SELECT a.id 
            FROM `accounts` AS a 
            WHERE a.id = from_account_id) IS NOT NULL
        AND (SELECT a.balance 
            FROM `accounts` AS a 
            WHERE a.id = from_account_id) >= money_amount
    THEN
        START TRANSACTION;
        
        UPDATE `accounts` AS a 
        SET 
            a.balance = a.balance + money_amount
        WHERE
            a.id = to_account_id;
            
        UPDATE `accounts` AS a 
        SET 
            a.balance = a.balance - money_amount
        WHERE
            a.id = from_account_id;
        
        IF (SELECT a.balance 
            FROM `accounts` AS a 
            WHERE a.id = from_account_id) < 0
            THEN ROLLBACK;
        ELSE
            COMMIT;
        END IF;
    END IF;
END $$
