CREATE DATABASE colonial_blog_db;

CREATE TABLE users(
id INT PRIMARY KEY AUTO_INCREMENT,
username VARCHAR(30) UNIQUE NOT NULL,
password VARCHAR(30) NOT NULL,
email VARCHAR(50) NOT NULL
);

CREATE TABLE categories(
id INT PRIMARY KEY AUTO_INCREMENT,
category VARCHAR(30) NOT NULL
);

CREATE TABLE articles(
id INT PRIMARY KEY AUTO_INCREMENT,
title VARCHAR(50) NOT NULL,
content TEXT(255) NOT NULL,
category_id INT 
);

CREATE TABLE comments(
id INT PRIMARY KEY AUTO_INCREMENT,
comment VARCHAR(255) NOT NULL,
article_id INT NOT NULL,
user_id INT NOT NULL
);

CREATE TABLE likes(
id INT PRIMARY KEY AUTO_INCREMENT, 
article_id INT,
comment_id INT,
user_id INT NOT NULL
);

CREATE TABLE users_articles(
user_id INT,
article_id INT
);

ALTER TABLE articles 
ADD CONSTRAINT fk_articles_categories
FOREIGN KEY (category_id)
REFERENCES categories(id);

ALTER TABLE users_articles
ADD CONSTRAINT fk_users_articles_users
FOREIGN KEY (user_id)
REFERENCES users(id);

ALTER TABLE users_articles
ADD CONSTRAINT fk_users_articles_articles
FOREIGN KEY (article_id)
REFERENCES articles(id);

ALTER TABLE comments
ADD CONSTRAINT fk_comments_articles
FOREIGN KEY (article_id)
REFERENCES articles(id);

ALTER TABLE comments 
ADD CONSTRAINT fk_comments_users
FOREIGN KEY (user_id)
REFERENCES users(id);

ALTER TABLE likes
ADD CONSTRAINT fk_likes_articles
FOREIGN KEY (article_id)
REFERENCES articles(id);

ALTER TABLE likes
ADD CONSTRAINT fk_likes_comments
FOREIGN KEY (comment_id)
REFERENCES comments(id);

ALTER TABLE likes
ADD CONSTRAINT fk_likes_users
FOREIGN KEY (user_id)
REFERENCES users(id);

/* 2. Data Insertion
You will have to INSERT records of data into the likes table, based on the users table.
For users with id between 16 and 20(inclusive), insert data in the likes table with the following values: 
•	For users with even id, the like will be on an article, else – comment.
•	Users’ username length will determine the article_id. 
•	Users’ email length will determine the comment_id.
*/

INSERT INTO likes(article_id, comment_id, user_id)
SELECT 
IF(u.id % 2 = 0, CHAR_LENGTH(u.username), null),
IF(u.id % 2 = 1, CHAR_LENGTH(u.email), null),
u.id
FROM users as u
WHERE u.id BETWEEN 16 AND 20;

#03. Update
UPDATE `comments` AS `c`
SET `c`.`comment` =
    (CASE
        WHEN c.`id` % 2 = 0 THEN 'Very good article.'
        WHEN c.`id` % 3 = 0 THEN 'This is interesting.'
        WHEN c.`id` % 5 = 0 THEN 'I definitely will read the article again.'
        WHEN c.`id` % 7 = 0 THEN 'The universe is such an amazing thing.'
        ELSE c.`comment`
    END)
WHERE c.`id` BETWEEN 1 AND 15;

/* 5. Extract 3 biggest articles
Extract from the database, the 3 biggest articles and summarize their content. The summary must be 20 symbols long plus "..." at the end. Order the results by article id.
Required Columns
•	title
•	summary
*/

SELECT nt.title, nt.summary
 FROM (SELECT a.id, a.title, concat(LEFT(a.content, 20),'...') as 'summary'
FROM articles as a
ORDER BY char_length(a.content) DESC
LIMIT 3) as nt
ORDER BY nt.id;

/* 6. Golden Articles
When article has the same id as its author, it is considered Golden Article. 
Extract from the database all golden articles. Order the results ascending by article id.
Required Columns
•	article_id
•	title
*/

SELECT a.id as 'article_id', a.title
FROM articles as a
JOIN users_articles as ua
ON a.id = ua.article_id
WHERE ua.article_id = ua.user_id
ORDER BY a.id ASC;

/* 7. Extract categories
Extract from the database, all categories with their articles, and likes.
 Order them by count of likes descending, then by article's count descending and lastly by category's id ascending.
Required Columns
•	category
•	articles (count of articles for the given category)
•	likes (total likes for the given category)
*/

#08. Extract the most commented 
SELECT a.title, COUNT(com.id) AS comments
FROM articles as a
JOIN categories as c
ON c.id = a.category_id
JOIN comments as com
ON com.article_id = a.id
WHERE c.category = 'Social'
GROUP BY a.id
ORDER BY comments DESC
LIMIT 1;

#09. Extract the less liked comments
SELECT CONCAT(LEFT(c.comment, 20), '...') AS summary
FROM comments AS c
LEFT JOIN likes AS l
ON c.id = l.comment_id
WHERE l.comment_id IS NULL
ORDER BY c.id DESC;

SELECT c. category, COUNT(DISTINCT a.id) as 'articles', COUNT(l.article_id) as 'likes'
FROM categories as c
JOIN articles as a
ON c.id = a.category_id
LEFT JOIN likes as l
ON a.id = l.article_id
GROUP BY a.category_id
ORDER BY likes DESC, articles DESC, c.id ASC; 

/* 10. Get user’s articles count
Create a user defined function with the name udf_users_articles_count(username VARCHAR(30))
 that receives a username and returns the number of articles this user has written.
*/
DELIMITER $$
CREATE FUNCTION udf_users_articles_count(p_username VARCHAR(30))
RETURNS INT 
DETERMINISTIC
BEGIN
     DECLARE result INT;
     SET result := (
     SELECT COUNT(ua.article_id)
     FROM users_articles AS ua
     RIGHT JOIN users AS u
     ON u.id = ua.user_id
     WHERE u.username = p_username
     GROUP BY u.id
     );
     RETURN result;
END $$

#11. Like Article
DELIMITER $$
CREATE PROCEDURE `udp_like_article` (`username` VARCHAR(30), `title` VARCHAR(30))
BEGIN
    IF ((SELECT u.`username` FROM `users` AS `u` WHERE u.`username` = `username`) IS NULL)
        THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Non-existent user.';
    ELSEIF ((SELECT a.`title` FROM `articles` AS `a` WHERE a.`title` = `title`) IS NULL)
        THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Non-existent article.';
    ELSE
        INSERT INTO `likes` (`article_id`, `comment_id`, `user_id`)
        SELECT (SELECT a.`id` FROM `articles` AS `a` WHERE a.`title` = `title`) AS `article_id`,
               NULL AS `comment_id`,
               (SELECT u.`id` FROM `users` AS `u` WHERE u.`username` = `username`) AS `user_id`;
    END IF;
END $$
DELIMITER $$
