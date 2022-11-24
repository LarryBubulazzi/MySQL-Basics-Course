#01. Create Tables
CREATE TABLE minions(
   id INT(11) PRIMARY KEY AUTO_INCREMENT,
   name VARCHAR(20),
   age INT(11)
);

CREATE TABLE towns (
   id INT(11) PRIMARY KEY AUTO_INCREMENT,
   name VARCHAR(20)
);

#02. Alter Minions Table
ALTER TABLE minions
ADD COLUMN town_id INT(11);

ALTER TABLE minions
ADD CONSTRAINT fk_minions_towns FOREIGN KEY(town_id) REFERENCES towns(id);

#03. Insert Records in Both Tables
INSERT INTO towns(id,name) VALUES(1,'Sofia');
INSERT INTO towns(id,name) VALUES(2,'Plovdiv');
INSERT INTO towns(id,name) VALUES(3,'Varna');

INSERT INTO minions(id,name,age,town_id) 
VALUES (1, 'Kevin', '22', '1'),(2, 'Bob', '15', '3'), (3, 'Steward', null, '2');

#04. Truncate Table Minions
TRUNCATE TABLE minions;

 #05. Drop All Tables
 DROP TABLES minions, towns;
 
 #06. Create Table People
 create table people(
id int(11) primary key auto_increment not null,
name varchar(200) not null,
picture tinyblob,
height double(3,2),
weight double(5,2),
gender enum('m', 'f') not null,
birthdate date not null,
biography text
);

insert into people(id, name, picture, height, weight, gender, birthdate, biography)
values
(1, 'pesho', null, 1.89, 45.0, 'm', '1994-02-22', 'az sum pesho'),
(2, 'gosho', null, 1.87, 45.0, 'm', '1993-12-15', 'az sum gosho'),
(3, 'mincho', null, 1.77, 45.0, 'm', '1994-02-14', 'az sum mincho'),
(4, 'sashko', null, 1.70, 45.0, 'm', '1994-03-09', 'az sum sashko'),
(5, 'kurcho', null, 1.90, 45.0, 'm', '1994-08-02', 'az sum kurcho');

#07. Create Table Users
CREATE TABLE users (
id INT UNIQUE PRIMARY KEY NOT NULL AUTO_INCREMENT,
username VARCHAR(30) NOT NULL UNIQUE,
password VARCHAR(26),
profile_picture TINYBLOB,
last_login_time TIMESTAMP,
is_deleted BOOLEAN
);

INSERT INTO users(id,username,password,profile_picture,last_login_time,is_deleted)
VALUES
(1,'Marincho', 'passMarincho', null, '1991-01-02 14:13:55', true),
(2,'Madurko', 'passMadurko', null, '1995-01-09 14:13:55', false),
(3,'Ivan', 'passIvan', null, '1996-08-02 14:17:55', true),
(4,'Ibrqm', 'passIbrqm', null, '1988-04-02 18:13:55', false),
(5,'Misho', 'passMisho', null, '2001-11-02 14:13:55', true);

#08. Change Primary Key
ALTER TABLE users DROP PRIMARY KEY,
ADD CONSTRAINT `pk_users` PRIMARY KEY(id, username);

#09. Set Default Value of a Field
ALTER TABLE users
MODIFY COLUMN `last_login_time` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP;

ALTER TABLE users
CHANGE COLUMN `last_login_time` `last_login_time` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP;

#10. Set Unique Field
ALTER TABLE users
DROP PRIMARY KEY,

ADD CONSTRAINT  PRIMARY KEY (id),
ADD CONSTRAINT UNIQUE(username);

#11. Movies Database
CREATE TABLE directors(
id INT UNIQUE PRIMARY KEY AUTO_INCREMENT NOT NULL,
director_name VARCHAR(40) NOT NULL,
notes TEXT
);

CREATE TABLE genres(
id INT UNIQUE PRIMARY KEY AUTO_INCREMENT NOT NULL,
genre_name VARCHAR(40),
notes TEXT
);

CREATE TABLE categories(
id INT UNIQUE PRIMARY KEY AUTO_INCREMENT NOT NULL,
category_name VARCHAR(40),
notes TEXT
);

CREATE TABLE movies(
id INT UNIQUE PRIMARY KEY AUTO_INCREMENT NOT NULL, 
title VARCHAR(40) NOT NULL, 
director_id INT NOT NULL, 
copyright_year YEAR, 
length TIME , 
genre_id INT NOT NULL, 
category_id INT NOT NULL, 
rating INT(40), 
notes TEXT
);

INSERT INTO directors(id, director_name, notes)
VALUES
(1, 'Ivan', 'meow'),
(2, 'Gosho', 'meow'),
(3, 'Pesho', 'meow'),
(4, 'Marian', 'meow'),
(5, 'Ivailo', 'meow'); 

INSERT INTO genres(id, genre_name, notes)
VALUES
(1, 'thriller', 'meow'),
(2, 'horror', 'meow'),
(3, 'drama', 'meow'),
(4, 'comedy', 'meow'),
(5, 'action', 'meow');

INSERT INTO categories(id, category_name, notes)
VALUES 
(1, 'best thriller', 'meow'),
(2, 'best horror', 'meow'),
(3, 'best drama', 'meow'),
(4, 'best comedy', 'meow'),
(5, 'best action', 'meow');

INSERT INTO movies(id, title, director_id, copyright_year, length, genre_id, category_id, rating, notes)
VALUES
(1, 'Taken', 1, '1999', '102', 3, 4, '78', 'awesome'),
(2, 'Scream', 2, '1998', '22', 3, 4, '48', 'yeyy'),
(3, 'Reign over me', 4, '2001', '323', 3, 4, '80', 'wow'),
(4, 'The Mask', 5, '1997', '323', 3, 4, '76', 'notess'),
(5, 'Heat', 3, '2007', '2323', 3, 4, '74', 'evala');

#12. Car Rental Database
CREATE TABLE categories(
id INT UNIQUE PRIMARY KEY NOT NULL AUTO_INCREMENT,
category VARCHAR(40), 
daily_rate DOUBLE,
 weekly_rate DOUBLE,
 monthly_rate DOUBLE,
 weekend_rate DOUBLE
);

INSERT INTO categories(id, category, daily_rate, weekly_rate, monthly_rate, weekend_rate)
VALUES
(1,'kote','2.1', 2.3, '3.3', '4.4'),
(2,'pate','2.1', 2.3, '3.3', '4.4'),
(3,'kuche','2.1', 2.3, '3.3', '4.4');


CREATE TABLE cars (
id INT UNIQUE PRIMARY KEY NOT NULL AUTO_INCREMENT, 
plate_number INT,
 make VARCHAR(30),
 model VARCHAR(30),
 car_year YEAR,
 category_id INT NOT NULL,
 doors VARCHAR(30),
 picture BLOB,
 car_condition VARCHAR(40),
 available BOOLEAN NOT NULL DEFAULT TRUE
);

INSERT INTO cars(id, plate_number, make, model, car_year, category_id, doors, picture, car_condition)
VALUES 
(1,3, 'Maker 1', 'Skoda', '1999', '1', '2', null, 'good'),
(2,3, 'Maker 2', 'Mercedes', '1989', '1', '4', null, 'good'),
(3,3, 'Maker 3', 'Opel', '2001', '2', '2', null, 'good');

CREATE TABLE employees (
id INT UNIQUE PRIMARY KEY NOT NULL AUTO_INCREMENT, 
first_name VARCHAR(30), 
last_name VARCHAR(30), 
title VARCHAR(30), 
notes TEXT
);

INSERT INTO employees (id, first_name, last_name, title, notes)
VALUES
(1, 'Kolio', 'Minchev', 'kote', 'meow'),
(2, 'Marincho', 'Ivanov', 'kuche', 'meow'),
(3, 'Madurko', 'Petrov', 'pile', 'meow');

CREATE TABLE customers (
id INT UNIQUE PRIMARY KEY NOT NULL AUTO_INCREMENT,
 driver_licence_number INT ,
 full_name VARCHAR(40),
 address VARCHAR(40),
 city VARCHAR(40), 
 zip_code INT,
 notes TEXT
); 

INSERT INTO customers(id, driver_licence_number, full_name, address, city, zip_code, notes)
VALUES
(1, 2233, 'Ivan Petrov Minchev', 'ulica 52', 'Rousse', '7011', 'meow'),
(2, 52633, 'Madurkoto Pisanev Svirchev', 'ulica 62', 'Sofia', '8011', 'meow'),
(3, 4233, 'Gergi Gergev Marinchev', 'ulica 66', 'Kazichene', '7661', 'meow');

CREATE TABLE rental_orders(
id INT PRIMARY KEY UNIQUE NOT NULL AUTO_INCREMENT, 
employee_id INT NOT NULL,
 customer_id INT NOT NULL,
 car_id INT NOT NULL,
 car_condition VARCHAR(40),
 tank_level INT,
 kilometrage_start INT,
 kilometrage_end INT, 
 total_kilometrage INT,
 start_date  DATE,
 end_date DATE,
 total_days INT,
 rate_applied DOUBLE,
 tax_rate DOUBLE, 
 order_status VARCHAR(40),
 notes text
);

INSERT INTO rental_orders (employee_id, customer_id, car_id, car_condition, order_status, notes)
 VALUES
 (1,1,2,'good', 'yes', 'meow'),
 (2,3,1,'bad', 'no', 'meow'),
 (3,2,3,'good', 'yes', 'meow');
 
 #13. Hotel Database
 CREATE TABLE `employees` (
	`id` INT UNSIGNED PRIMARY KEY NOT NULL UNIQUE AUTO_INCREMENT,
	`first_name` VARCHAR(30) NOT NULL,
	`last_name` VARCHAR(30) NOT NULL,
	`title` VARCHAR(30) NOT NULL,
	`notes` VARCHAR(128)
);

INSERT INTO `employees`
		(`first_name`, `last_name`, `title`, `notes`)
	VALUES 
		('Gosho', 'Goshev', 'Boss', ''),
		('Pesho', 'Peshev', 'Supervisor', ''),
		('Bai', 'Ivan', 'Worker', 'Can do any work');

CREATE TABLE `customers` (
	`account_number` INT UNSIGNED PRIMARY KEY NOT NULL UNIQUE AUTO_INCREMENT,
	`first_name` VARCHAR(30) NOT NULL,
	`last_name` VARCHAR(30) NOT NULL,
	`phone_number` VARCHAR(20) NOT NULL,
	`emergency_name` VARCHAR(50),
	`emergency_number` VARCHAR(20),
	`notes` VARCHAR(128)
);

INSERT INTO `customers`
		(`first_name`, `last_name`, `phone_number`)
	VALUES 
		('Gosho', 'Goshev', '123'),
		('Pesho', 'Peshev', '44-2432'),
		('Bai', 'Ivan', '007');

CREATE TABLE `room_status` (
	`room_status` INT UNSIGNED PRIMARY KEY NOT NULL UNIQUE AUTO_INCREMENT,
	`notes` VARCHAR(128)
);

INSERT INTO `room_status` 
		(`notes`)
	VALUES 
		('Free'),
		('For clean'),
		('Occupied');

CREATE TABLE `room_types` (
	`room_type` INT UNSIGNED PRIMARY KEY NOT NULL UNIQUE AUTO_INCREMENT,
	`notes` VARCHAR(128)
);

INSERT INTO `room_types` 
		(`notes`)
	VALUES 
		('Small'),
		('Medium'),
		('Appartment');


CREATE TABLE `bed_types` (
	`bed_type` INT UNSIGNED PRIMARY KEY NOT NULL UNIQUE AUTO_INCREMENT,
	`notes` VARCHAR(128)
);

INSERT INTO `bed_types` 
		(`notes`)
	VALUES 
		('Single'),
		('Double'),
		('Water-filled');

CREATE TABLE `rooms` (
	`room_number` INT UNSIGNED PRIMARY KEY NOT NULL UNIQUE AUTO_INCREMENT,
	`room_type` INT UNSIGNED NOT NULL,
	`bed_type` INT UNSIGNED NOT NULL,
	`rate` DOUBLE DEFAULT 0,
	`room_status` INT UNSIGNED NOT NULL,
	`notes` VARCHAR(128)
);

INSERT INTO `rooms` 
		(`room_type`, `bed_type`, `room_status`)
	VALUES 
		(1, 1, 1),
		(2, 2, 2),
		(3, 3, 3);

CREATE TABLE `payments` (
	`id` INT UNSIGNED PRIMARY KEY NOT NULL UNIQUE AUTO_INCREMENT,
	`employee_id` INT UNSIGNED NOT NULL,
	`payment_date` DATE NOT NULL,
	`account_number` INT UNSIGNED NOT NULL,
	`first_date_occupied` DATE,
	`last_date_occupied` DATE,
	`total_days` INT UNSIGNED,
	`amount_charged` DOUBLE,
	`tax_rate` DOUBLE,
	`tax_amount` DOUBLE,
	`payment_total` DOUBLE,
	`notes` VARCHAR(128)
);

INSERT INTO `payments` 
		(`employee_id`, `payment_date`, `account_number`)
	VALUES 
		(1, DATE(NOW()), 1),
		(2, DATE(NOW()), 2),
		(3, DATE(NOW()), 3);


CREATE TABLE `occupancies` (
	`id` INT UNSIGNED PRIMARY KEY NOT NULL UNIQUE AUTO_INCREMENT,
	`employee_id` INT UNSIGNED NOT NULL,
	`date_occupied` DATE NOT NULL,
	`account_number` INT UNSIGNED NOT NULL,
	`room_number` INT UNSIGNED NOT NULL,
	`rate_applied` DOUBLE,
	`phone_charge` DOUBLE,
	`notes` VARCHAR(128)
);

INSERT INTO `occupancies` 
		(`employee_id`, `date_occupied`, `account_number`, `room_number`)
	VALUES 
		(1, DATE(NOW()), 1, 1),
		(2, DATE(NOW()), 2, 2),
		(3, DATE(NOW()), 3, 3);
        
#14. Create SoftUni Database
CREATE TABLE `towns`(
`id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
`name` VARCHAR(30) NOT NULL
);

CREATE TABLE `addresses`(
`id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
`address_text` VARCHAR(255),
`town_id` INT,
CONSTRAINT fk_addresses_towns
FOREIGN KEY `addresses`(`town_id`)
REFERENCES `towns`(`id`) 
);

CREATE TABLE `departments`(
`id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
`name` VARCHAR(50) NOT NULL
);

CREATE TABLE `employees`(
`id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
`first_name` VARCHAR(45),
`middle_name` VARCHAR(45),
`last_name` VARCHAR(45),
`job_title` VARCHAR(45),
`department_id` INT,
`hire_date` DATE,
`salary` DECIMAL(10,2),
`address_id` INT,

CONSTRAINT fk_employees_departments
FOREIGN KEY `employees`(`department_id`)
REFERENCES `departments`(`id`),

CONSTRAINT fk_employees_addresses
FOREIGN KEY `employees`(`address_id`)
REFERENCES `addresses`(`id`)
);

#15. Basic Insert
INSERT INTO `towns`(`id`, `name`)
VALUES 
(1,'Sofia'),
(2,'Plovdiv'),
(3,'Varna'),
(4,'Burgas');

INSERT INTO `departments`
(`id`, `name`)
VALUES
(1,'Engineering'),
(2,'Sales'),
(3,'Marketing'),
(4,'Software Development'),
(5,'Quality Assurance');

INSERT INTO `employees`
(`id`,
`first_name`,
`middle_name`,
`last_name`,
`job_title`,
`department_id`,
`hire_date`,
`salary`)
VALUES
(1, 'Ivan', 'Ivanov', 'Ivanov', '.NET Developer', 4, '2013/02/01','3500.00'),
(2, 'Petar', 'Petrov', 'Petrov', 'Senior Engineer', 1, '2004/03/02','4000.00'),
(3, 'Maria', 'Petrova', 'Ivanova', 'Intern', 5, '2016/08/28','525.25'),
(4, 'Georgi', 'Terziev', 'Ivanov', 'CEO', 2, '2007/12/09','3000.00'),
(5, 'Peter', 'Pan', 'Pan', 'Intern', 3, '2016/08/28','599.88');

#16. Basic Select All Fields
SELECT * FROM `towns`;
SELECT * FROM `departments`;
SELECT * FROM `employees`;

#17. Basic Select All Fields and Order 
SELECT * FROM `towns` ORDER BY `name`;
SELECT * FROM `departments` ORDER BY `name`;
SELECT * FROM `employees` ORDER BY `salary` DESC;

#18. Basic Select Some Fields
SELECT `name` FROM `towns` ORDER BY `name`;
SELECT `name` FROM `departments` ORDER BY `name`;
SELECT `first_name`, `last_name`, `job_title`, `salary` FROM `employees` ORDER BY `salary` DESC;

#19. Increase Employees Salary
UPDATE `employees`
SET `salary` =`salary`*1.1;
SELECT `salary` FROM `employees`;

#20. Decrease Tax Rate
UPDATE payments
SET tax_rate=tax_rate*0.97;
SELECT tax_rate FROM payments;

#21. Delete All Records
TRUNCATE TABLE occupancies;
SELECT*FROM occupancies;       
