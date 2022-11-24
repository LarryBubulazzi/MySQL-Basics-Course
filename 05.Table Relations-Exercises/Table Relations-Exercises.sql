#01. One-To-One Relationship
CREATE TABLE passports(
passport_id INT PRIMARY KEY,
passport_number VARCHAR(20) UNIQUE
);

INSERT INTO passports
VALUES
(101, 'N34FG21B'),
(102, 'K65LO4R7'),
(103, 'ZE657QP2');

CREATE TABLE persons(
person_id INT AUTO_INCREMENT PRIMARY KEY,
first_name VARCHAR(20),
salary DECIMAL(10,2),
passport_id INT UNIQUE
);

ALTER TABLE persons 
ADD CONSTRAINT fk_persons_passports
FOREIGN KEY persons(passport_id)
REFERENCES passports(passport_id);

INSERT INTO persons
VALUES
(1, 'Roberto', '43300.00', 102),
(2, 'Tom', '56100.00', 103),
(3, 'Yana', '60200.00', 101);

#02. One-To-Many Relationship
CREATE TABLE manufacturers(
manufacturer_id INT AUTO_INCREMENT PRIMARY KEY,
name VARCHAR(20),
established_on DATE
);

INSERT INTO manufacturers(name, established_on)
VALUES
('BMW', '1916-03-01'),
('Tesla', '2003-01-01'),
('Lada', '1966-05-01');

CREATE TABLE models(
model_id INT PRIMARY KEY,
name VARCHAR(20),
manufacturer_id INT,

CONSTRAINT fk_models_manufacturers
FOREIGN KEY (manufacturer_id)
REFERENCES manufacturers(manufacturer_id)
);

INSERT INTO models
VALUES
(101, 'X1', 1),
(102, 'i6', 1),
(103, 'Model S', 2),
(104, 'Model X', 2),
(105, 'Model 3', 2),
(106, 'Nova', 3);

#04. Self-Referencing
CREATE TABLE `teachers` (
    `teacher_id` INT PRIMARY KEY,
    `name` VARCHAR(20) NOT NULL,
    `manager_id` INT NULL
);

INSERT INTO `teachers` VALUES
    (101, 'John', NULL),
    (102, 'Maya', 106),
    (103, 'Silvia', 106),
    (104, 'Ted', 105),
    (105, 'Mark', 101),
    (106, 'Greta', 101);

ALTER TABLE `teachers`
ADD CONSTRAINT `fk_teachers_teachers`
FOREIGN KEY (`manager_id`)
REFERENCES `teachers`(`teacher_id`);

#05. Online Store Database
CREATE TABLE cities(
city_id INT AUTO_INCREMENT PRIMARY KEY,
name VARCHAR(50)
);

CREATE TABLE customers(
customer_id INT AUTO_INCREMENT PRIMARY KEY,
name VARCHAR(50),
birthday DATE,
city_id INT,

CONSTRAINT fk_customers_cities
FOREIGN KEY customers(city_id)
REFERENCES cities(city_id) 
);

CREATE TABLE orders(
order_id INT AUTO_INCREMENT PRIMARY KEY,
customer_id INT,

CONSTRAINT fk_orders_customers
FOREIGN KEY (customer_id)
REFERENCES customers(customer_id)
);

CREATE TABLE item_types(
item_type_id INT AUTO_INCREMENT PRIMARY KEY,
name VARCHAR(50)
);

CREATE TABLE items (
item_id INT AUTO_INCREMENT PRIMARY KEY,
name VARCHAR(50),
item_type_id INT,

CONSTRAINT fk_items_item_types
FOREIGN KEY (item_type_id)
REFERENCES item_types(item_type_id)
);

CREATE TABLE order_items(
order_id INT,
item_id INT,

CONSTRAINT pk_order_items
PRIMARY KEY(order_id, item_id),

CONSTRAINT fk_order_items_orders
FOREIGN KEY order_items(order_id)
REFERENCES orders(order_id),

CONSTRAINT fk_order_items_items
FOREIGN KEY order_items(item_id)
REFERENCES items(item_id)

);

#06. University Database
CREATE TABLE majors(
major_id INT PRIMARY KEY AUTO_INCREMENT,
name VARCHAR(50)
);

CREATE TABLE students(
student_id INT PRIMARY KEY AUTO_INCREMENT,
student_number VARCHAR(12),
student_name VARCHAR(50),
major_id INT,

CONSTRAINT fk_students_majors
FOREIGN KEY students(major_id)
REFERENCES majors(major_id)
);

CREATE TABLE payments(
payment_id INT PRIMARY KEY AUTO_INCREMENT,
payment_date DATE,
payment_amount DECIMAL(8,2),
student_id INT,

CONSTRAINT fk_payments_students
FOREIGN KEY payments(student_id)
REFERENCES students(student_id)
);

CREATE TABLE subjects(
subject_id INT PRIMARY KEY AUTO_INCREMENT,
subject_name VARCHAR(50)
);

CREATE TABLE agenda(
student_id INT,
subject_id INT,

CONSTRAINT pk_agenda
PRIMARY KEY(student_id, subject_id),

CONSTRAINT fk_agenda_students
FOREIGN KEY agenda(student_id)
REFERENCES students(student_id)

);

ALTER TABLE agenda
ADD CONSTRAINT fk_agenda_subjects
FOREIGN KEY agenda(subject_id)
REFERENCES subjects(subject_id);

#09. Peaks in Rila
SELECT m.mountain_range, p.peak_name, p.elevation AS 'peak_elevation' 
FROM mountains AS m
JOIN peaks AS p
ON m.id = p.mountain_id
WHERE mountain_range = 'Rila'
ORDER BY p.elevation DESC;
