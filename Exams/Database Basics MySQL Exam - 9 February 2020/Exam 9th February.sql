# 01. Table Design
CREATE TABLE countries(
id INT PRIMARY KEY AUTO_INCREMENT,
name VARCHAR(45) NOT NULL
);

CREATE TABLE towns(
id INT PRIMARY KEY AUTO_INCREMENT,
name VARCHAR(45) NOT NULL,
country_id INT NOT NULL,

CONSTRAINT fk_towns_countries
FOREIGN KEY towns(country_id)
REFERENCES countries(id)
);

CREATE TABLE stadiums(
id INT PRIMARY KEY AUTO_INCREMENT,
name VARCHAR(45) NOT NULL,
capacity INT NOT NULL,
town_id INT NOT NULL,

CONSTRAINT fk_stadiums_towns
FOREIGN KEY stadiums(town_id)
REFERENCES towns(id)
);

CREATE TABLE teams(
id INT PRIMARY KEY AUTO_INCREMENT,
name VARCHAR(45) NOT NULL,
established DATE NOT NULL,
fan_base BIGINT DEFAULT 0 NOT NULL,
stadium_id INT NOT NULL,

CONSTRAINT fk_teams_stadiums
FOREIGN KEY teams(stadium_id)
REFERENCES stadiums(id)
);

CREATE TABLE skills_data(
id INT PRIMARY KEY AUTO_INCREMENT,
dribbling INT DEFAULT 0,
pace INT DEFAULT 0,
passing INT DEFAULT 0,
shooting INT DEFAULT 0,
speed INT DEFAULT 0,
strength INT DEFAULT 0
);

CREATE TABLE players(
id INT PRIMARY KEY AUTO_INCREMENT,
first_name VARCHAR(10) NOT NULL,
last_name VARCHAR(20) NOT NULL,
age INT DEFAULT 0 NOT NULL,
position CHAR(1) DEFAULT 0 NOT NULL,
salary DECIMAL(10,2) DEFAULT 0 NOT NULL,
hire_date DATETIME,
skills_data_id INT DEFAULT 0 NOT NULL,
team_id INT,

CONSTRAINT fk_players_skills_data
FOREIGN KEY players(skills_data_id)
REFERENCES skills_data(id),

CONSTRAINT fk_players_teams
FOREIGN KEY players(team_id)
REFERENCES teams(id)
);

CREATE TABLE coaches( 
id INT PRIMARY KEY AUTO_INCREMENT,
first_name VARCHAR(10) NOT NULL,
last_name VARCHAR(20) NOT NULL,
salary DECIMAL(10,2) DEFAULT 0 NOT NULL,
coach_level INT DEFAULT 0 NOT NULL
);

CREATE TABLE players_coaches(
player_id INT,
coach_id INT,

CONSTRAINT pk_player_coaches
PRIMARY KEY(player_id, coach_id),

CONSTRAINT fk_player_coaches_coaches
FOREIGN KEY players_coaches(coach_id)
REFERENCES coaches(id),

CONSTRAINT fk_player_coaches_players
FOREIGN KEY player_coaches(player_id)
REFERENCES players(id) 
);

/* 05.	Players 
Extract from the Football Scout Database (fsd) database, info about all of the players. 
Order the results by players - salary descending.
Required Columns
•	first_name
•	age
•	salary
*/

SELECT first_name, age, salary FROM players
ORDER BY salary DESC;

/* 06. One of the coaches wants to know more about all the young players (under age of 20) who can strengthen his team in the offensive (played on position ‘A’). 
As he is not paying a transfer amount, he is looking only for those who have not signed a contract so far (haven’t hire_date) and have strength of more than 50. 
Order the results ascending by salary, then by age.
Required Columns
•	id (player)
•	full_name 
•	age
•	position
•	hire_date
*/

SELECT p.id, CONCAT(p.first_name, ' ', p.last_name) AS full_name, p.age, p.position, p.hire_date
FROM players AS p
JOIN skills_data AS sd
ON p.skills_data_id = sd.id
WHERE age < 23 AND position = 'A' AND hire_date IS NULL AND sd.strength >= 50
ORDER BY salary, age; 

/* 07.	Detail info for all teams
Extract from the database all of the teams and the count of the players that they have.
Order the results descending by count of players, then by fan_base descending. 
Required Columns
•	team_name
•	established
•	fan_base
•	count_of_players
*/

SELECT t.name AS team_name, t.established, t.fan_base, COUNT(p.team_id) AS 'players_count'
FROM players as p
RIGHT JOIN teams as t
ON p.team_id = t.id
GROUP BY t.id
ORDER BY `players_count` DESC, t.fan_base DESC;

/* 08.The fastest player by towns
Extract from the database, the fastest player (having max speed), in terms of towns where their team played.
Order players by speed descending, then by town name.
Skip players that played in team ‘Devify’
Required Columns
•	max_speed
•	town_name
*/

SELECT MAX(sd.speed) AS 'max_speed', t.name AS 'town_name'
FROM teams AS tm
LEFT JOIN players as p
ON tm.id = p.team_id
LEFT JOIN stadiums AS st
ON st.id = tm.stadium_id
LEFT JOIN towns as t
ON st.town_id = t.id
LEFT JOIN skills_data as sd
ON sd.id = p.skills_data_id
WHERE tm.name != 'Devify'
GROUP BY t.id
ORDER BY max_speed DESC, t.name;

SELECT MAX(sd.speed) max_speed, tw.name
#p.*, sd.*
FROM teams t
LEFT JOIN players p
ON p.team_id = t.id
LEFT JOIN stadiums s
ON s.id = t.stadium_id
LEFT JOIN towns tw
ON s.town_id = tw.id
LEFT JOIN skills_data sd
ON p.skills_data_id = sd.id
WHERE t.name != 'Devify'
GROUP BY tw.id
ORDER BY max_speed DESC, tw.name;

/* 09.Total salaries and players by country
And like everything else in this world, everything is ultimately about finances.
 Now you need to extract detailed information on the amount of all salaries given to football players by the criteria of the country in which they played.
If there are no players in a country, display NULL.  Order the results by total count of players in descending order, then by country name alphabetically.
Required Columns
•	name (country)
•	total_sum_of_salaries
•	total_count_of_players
*/

SELECT c.name, COUNT(p.id) AS 'total_count_of_players', SUM(p.salary) AS 'total_sum_of_salaries'
FROM countries as c
LEFT JOIN towns as t
ON c.id = t.country_id
LEFT JOIN stadiums as st
ON t.id = st.town_id
LEFT JOIN teams as tm
ON tm.stadium_id = st.id
LEFT JOIN players as p
ON p.team_id = tm.id
GROUP BY c.name
ORDER BY total_count_of_players DESC, c.name;

/* 02.Insert
You will have to insert records of data into the coaches table, based on the players table. 
For players with age over 45 (inclusive), insert data in the coaches table with the following values:
•	first_name – set it to first name of the player
•	last_name – set it to last name of the player.
•	salary – set it to double as player’s salary. 
•	coach_level – set it to be equals to count of the characters in player’s first_name.
*/

INSERT INTO coaches(first_name, last_name, salary, coach_level )
(
SELECT p.first_name, p.last_name, p.salary*2, CHAR_LENGTH(p.first_name) 
FROM players as p
WHERE p.age >= 45
);

/* 03.Update
Update all coaches, who train one or more players and their first_name starts with ‘A’. Increase their level with 1.
*/

UPDATE coaches AS c
SET c.coach_level = c.coach_level +1 
WHERE c.first_name LIKE 'A%' AND 
(SELECT COUNT(pc.player_id) FROM players_coaches AS pc WHERE pc.coach_id = c.id) >=1;

/* 04.	Delete
As you remember at the beginning of our work, we promoted several football players to coaches. Now you need to remove all of them from the table of players in order for our database to be updated accordingly.	
Delete all players from table players, which are already added in table coaches. 
*/

DELETE FROM players
WHERE age >= 45;

/* 10. Find all players that play on stadium
Create a user defined function with the name udf_stadium_players_count (stadium_name VARCHAR(30)) that receives a stadium’s name 
and returns the number of players that play home matches there.
*/
DELIMITER $$
CREATE FUNCTION udf_stadium_players_count(stadium_name VARCHAR(30))
RETURNS INT
DETERMINISTIC
BEGIN
DECLARE p_count INT;
SET p_count :=(SELECT count(p.id) AS 'count'
FROM players as p
JOIN teams as t
ON p.team_id = t.id
JOIN stadiums as s
ON t.stadium_id = s.id
WHERE s.name = stadium_name);
RETURN p_count;
END $$


/* 11. Find good playmaker by teams
Create a stored procedure udp_find_playmaker which accepts the following parameters:
•	min_dribble_points 
•	team_name (with max length 45)
 And extracts data about the players with the given skill stats (more than min_dribble_points), played for given team (team_name) and have more than average speed for all players. Order players by speed descending. Select only the best one.
Show all needed info for this player: full_name, age, salary, dribbling, speed, team name.
CALL udp_find_playmaker (20, ‘Skyble’);
*/
DELIMITER $$
CREATE PROCEDURE udp_find_playmaker(min_dribble_points INT, team_name VARCHAR(45))
BEGIN
SELECT CONCAT(p.first_name, ' ', p.last_name) as 'full_name', p.age, p.salary, sd.dribbling, sd.speed, t.name as 'team_name'  
FROM teams as t
JOIN  players as p
ON t.id = p.team_id
JOIN skills_data as sd
ON p.skills_data_id = sd.id
WHERE sd.dribbling > min_dribble_points AND t.name = team_name AND 
sd.speed > (SELECT AVG(sd.speed) FROM skills_data as sd)
ORDER BY sd.speed DESC
LIMIT 1;
END $$ 
