CREATE DATABASE colonial_journey_management_system_db;

CREATE TABLE planets(
id INT PRIMARY KEY AUTO_INCREMENT,
name VARCHAR(30) NOT NULL
);

CREATE TABLE spaceports(
id INT PRIMARY KEY AUTO_INCREMENT,
name VARCHAR(50) NOT NULL,
planet_id INT
);

CREATE TABLE journeys(
id INT PRIMARY KEY AUTO_INCREMENT,
journey_start DATETIME NOT NULL,
journey_end DATETIME NOT NULL,
purpose ENUM('Medical', 'Technical', 'Educational', 'Military') NOT NULL,
destination_spaceport_id INT,
spaceship_id INT
);

CREATE TABLE spaceships(
id INT PRIMARY KEY AUTO_INCREMENT,
name VARCHAR(50) NOT NULL,
manufacturer VARCHAR(30) NOT NULL,
light_speed_rate INT DEFAULT 0
);

CREATE TABLE travel_cards(
id INT PRIMARY KEY AUTO_INCREMENT,
card_number CHAR(10) UNIQUE NOT NULL,
job_during_journey ENUM('Pilot', 'Engineer', 'Trooper', 'Cleaner', 'Cook') NOT NULL,
colonist_id INT,
journey_id INT
);

CREATE TABLE colonists(
id INT PRIMARY KEY AUTO_INCREMENT,
first_name VARCHAR(20) NOT NULL,
last_name VARCHAR(20) NOT NULL,
ucn CHAR(10) UNIQUE NOT NULL,
birth_date DATE NOT NULL
);

ALTER TABLE spaceports
ADD CONSTRAINT fk_spaceports_planets
FOREIGN KEY spaceports(planet_id)
REFERENCES planets(id);

ALTER TABLE journeys
ADD CONSTRAINT fk_journeys_spaceports
FOREIGN KEY (destination_spaceport_id)
REFERENCES spaceports(id);

ALTER TABLE journeys
ADD CONSTRAINT fk_journeys_spaceships
FOREIGN KEY (spaceship_id)
REFERENCES spaceships(id);

ALTER TABLE travel_cards
ADD CONSTRAINT fk_travel_cards_journeys
FOREIGN KEY (journey_id)
REFERENCES journeys(id);

ALTER TABLE travel_cards
ADD CONSTRAINT fk_travel_cards_colonists
FOREIGN KEY (colonist_id)
REFERENCES colonists(id);

/* 01.	Data Insertion
You will have to INSERT records of data into the travel_cards table, based on the colonists table.
For colonists with id between 96 and 100(inclusive), insert data in the travel_cards table with the following values: 
•	For colonists born after ‘1980-01-01’, the card_number must be combination between the year of birth, day and the first 4 digits from the ucn. For the rest – year of birth, month and the last 4 digits from the ucn.
•	For colonists with id that can be divided by 2 without remainder, job must be ‘Pilot’, for colonists with id that can be divided by 3 without remainder – ‘Cook’, and everyone else – ‘Engineer’.
•	Journey id is the first digit from the colonist’s ucn.
*/

INSERT INTO travel_cards(card_number, job_during_journey, colonist_id, journey_id)
SELECT
(CASE
WHEN birth_date > '1980-01-01' THEN CONCAT(YEAR(birth_date), DAY(birth_date), LEFT(ucn, 4))
ELSE CONCAT(YEAR(birth_date), MONTH(birth_date), RIGHT(ucn, 4))
END) AS cardnum,
(CASE
WHEN id % 2 = 0 THEN 'Pilot'
WHEN id% 3 = 0 THEN 'Cook'
ELSE 'Engineer'
END) AS job, 
id AS colonist,
SUBSTRING(ucn,1,1) AS journey
FROM colonists as c
WHERE id >= 96 AND id <= 100;

/* 02. Data Update
UPDATE those journeys’ purpose, which meet the following conditions:
•	If the journey’s id is dividable by 2 without remainder – ‘Medical’.
•	If the journey’s id is dividable by 3 without remainder – ‘Technical’.
•	If the journey’s id is dividable by 5 without remainder – ‘Educational’.
•	If the journey’s id is dividable by 7 without remainder – ‘Military’. 
*/

UPDATE journeys as j
SET j.purpose =
(
CASE
    WHEN j.`id` % 2 = 0 THEN 'Medical'
    WHEN j.`id` % 3 = 0 THEN 'Technical'
    WHEN j.`id` % 5 = 0 THEN 'Educational'
    WHEN j.`id` % 7 = 0 THEN 'Military'
    ELSE j.`purpose`
    END);
    
    /* 03.	Data Deletion
REMOVE from colonists, those which are not assigned to any journey.
    */
    
DELETE FROM colonists    
WHERE id NOT IN 
(SELECT tc.colonist_id FROM travel_cards AS tc); 

/* 04. Extract all travel cards
Extract from the database, all travel cards. Sort the results by card number ascending.
Required Columns
•	card_number
•	job_during_journey
*/

SELECT card_number, job_during_journey
FROM travel_cards
ORDER BY card_number;

/* 05.Extract from the database, all colonists. Sort the results by first name, them by last name, and finally by id in ascending order.
Required Columns
•	id
•	full_name(first_name + last_name separated by a single space)
•	ucn
*/

SELECT id, CONCAT(first_name, ' ' , last_name) AS 'full_name', ucn
FROM colonists
ORDER BY first_name, last_name, id;

/* 06.Extract all military journeys
Extract from the database, all Military journeys. Sort the results ascending by journey start.
Required Columns
•	id
•	journey_start
•	journey_end
*/

SELECT id, journey_start, journey_end 
FROM journeys
WHERE purpose = 'Military'
ORDER BY journey_start ASC;

/* 07.Extract all pilots
Extract from the database all colonists, which have a pilot job. Sort the result by id, ascending.
Required Columns
•	id
•	full_name
*/

SELECT c.id, CONCAT(c.first_name, ' ', c.last_name) AS full_name
FROM colonists AS c
JOIN travel_cards AS tc
ON c.id = tc.colonist_id
WHERE tc.job_during_journey = 'Pilot'
ORDER BY id;

/*08. Count all colonists that are on technical journey
Count all colonists, that are on technical journey. 
Required Columns
•	Count
*/

SELECT COUNT(c.id) AS count
FROM colonists AS c
JOIN travel_cards AS tc
ON c.id = tc.colonist_id
JOIN journeys AS j
ON j.id = tc.journey_id
WHERE j.purpose = 'Technical';

/* 09.Extract the fastest spaceship
Extract from the database the fastest spaceship and its destination spaceport name. In other words, the ship with the highest light speed rate.
Required Columns
•	spaceship_name
•	spaceport_name
*/

SELECT sship.name AS 'spaceship_name', sport.name AS 'spaceport_name'
FROM spaceships AS sship
JOIN journeys as j
ON j.spaceship_id = sship.id
JOIN spaceports AS sport
ON j.destination_spaceport_id = sport.id
ORDER BY sship.light_speed_rate DESC
LIMIT 1;

/* 10.Extract spaceships with pilots younger than 30 years
Extract from the database those spaceships, which have pilots, younger than 30 years old. In other words, 30 years from 01/01/2019. Sort the results alphabetically by spaceship name.
Required Columns
•	name
•	manufacturer
*/

SELECT ship.name, ship.manufacturer 
FROM spaceships as ship
JOIN journeys as j
ON j.spaceship_id = ship.id
JOIN travel_cards as tc
ON tc.journey_id = j.id
JOIN colonists as c
ON c.id = tc.colonist_id
WHERE year(c.birth_date) > year(DATE_SUB('2019-01-01', INTERVAL 30 YEAR))
AND tc.job_during_journey = 'Pilot'
ORDER BY ship.name;

/* 11. Extract all educational mission planets and spaceports
Extract from the database names of all planets and their spaceports, which have educational missions. Sort the results by spaceport name in descending order.
Required Columns
•	planet_name
•	spaceport_name
*/

SELECT p.name AS 'planet_name', s.name as 'spaceport_name'
FROM planets as p
JOIN spaceports as s
ON p.id = s.planet_id
JOIN journeys as j
ON j.destination_spaceport_id = s.id
WHERE j.purpose = 'Educational'
ORDER BY s.name DESC;

/* 12. Extract all planets and their journey count
Extract from the database all planets’ names and their journeys count. Order the results by journeys count, descending and by planet name ascending.
Required Columns
•	planet_name
•	journeys_count
*/

SELECT p.name AS 'planet_name', COUNT(sp.planet_id) AS journeys_count
FROM planets as p
JOIN spaceports as sp
ON p.id = sp.planet_id
JOIN journeys as j
ON sp.id = j.destination_spaceport_id
GROUP BY sp.planet_id
ORDER BY journeys_count DESC, p.name;

/* 13.Extract the shortest journey
Extract from the database the shortest journey, its destination spaceport name, planet name and purpose.
Required Columns
•	Id
•	planet_name
•	spaceport_name
•	journey_purpose
*/

SELECT j.id, p.name AS 'planet_name', sp.name AS 'spaceport_name', j.purpose AS 'journey_purpose'
FROM journeys as j
JOIN spaceports as sp
ON j.destination_spaceport_id = sp.id
JOIN planets as p
ON sp.planet_id = p.id
ORDER BY DATEDIFF(j.journey_end, j.journey_start)
LIMIT 1;

/* 14.Extract the less popular job
Extract from the database the less popular job in the longest journey. In other words, the job with less assign colonists.
Required Columns
•	job_name
*/

SELECT tc.job_during_journey AS 'job_name' #DATEDIFF(journey_end, journey_start)
FROM travel_cards as tc
JOIN journeys as j
ON j.id = tc.journey_id
ORDER BY DATEDIFF(j.journey_end, j.journey_start) DESC
LIMIT 1;

/* 15. Get colonists count
Create a user defined function with the name udf_count_colonists_by_destination_planet (planet_name VARCHAR (30)) 
that receives planet name and returns the count of all colonists sent to that planet.
*/

DELIMITER $$
CREATE FUNCTION udf_count_colonists_by_destination_planet (planet_name VARCHAR(30))
RETURNS INT
DETERMINISTIC
BEGIN
DECLARE count_col INT;
SET count_col := (SELECT COUNT(c.id) AS count
FROM planets AS p
JOIN spaceports as s
ON p.id = s.planet_id
JOIN journeys as j
ON j.destination_spaceport_id = s.id
JOIN travel_cards as tc
ON tc.journey_id = j.id
JOIN colonists as c
ON c.id = tc.colonist_id
WHERE p.name = planet_name);
RETURN count_col;
END $$
