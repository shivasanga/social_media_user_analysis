--Instagram User Analytics
--Description:
--User analysis is the process by which we track how users engeage and interact with our digital
--product (software or mobile application)
--in an attempt to derive business for marketing, product & development teams.



--Creating User Schema
CREATE USER C##/*Your Schema Name*/ IDENTIFIED BY /*Your password*/ 

GRANT CONNECT TO C##/*Your Schema Name*/ ;

GRANT RESOURCE TO C##/*Your Schema Name*/
ALTER USER C##/*Your Schema Name*/ QUOTA unlimited ON USERS;

--Connect to your schema database

CONNECT
/*Your schema name / your password */ @ORCL;


--Data Exploration
--total tables we have
SELECT * FROM users;
SELECT * FROM comments;
SELECT * FROM follows;
SELECT * FROM likes;
SELECT * FROM photo_tags;
SELECT * FROM photos;
SELECT * FROM tags;

--how many total users we have
SELECT COUNT(*) AS total_users
FROM users;


--Data Analysis & Business Key Problems & Answers.

--A)Marketing: 
--Q1. Find the 5 oldest users of the Instagram from the database provided 
--Q2.Find the users who have never posted a single photo on Instagram
--Q3. Identify the winner of the contest and provide their details to the team
--Q4.Identify and suggest the top 5 most commonly used hashtags on the platform
--Q5.What day of the week do most users register on? Provide insights on when to schedule an AD campaign

--B) Investor Metrics: 
--Q6.Provide how many times does average user posts on Instagram. Also, provide the total number of 
--photos on Instagram and total number of users
--Q7.Provide data on users (bots) who have liked every single photo on the site (since any normal user would
--not able to do this).

--My Findings
--Q1. Find the 5 oldest users of the Instagram from the database provided 
SELECT * FROM users;

SELECT
    username,
    created_at
FROM
    users
ORDER BY
    created_at
FETCH FIRST 5 ROWS ONLY;


--Q2.Find the users who have never posted a single photo on Instagram
SELECT * FROM photos,users;

SELECT
    u.username
FROM
    users  u
    LEFT JOIN photos p ON p.user_id = u.id
WHERE
    p.image_url IS NULL
ORDER BY
    u.username;
    
--Q3. Identify the winner of the contest and provide their details to the team
SELECT * FROM likes,photos,users;

SELECT
    l.photo_id,
    u.username,
    COUNT(l.user_id) AS likess
FROM
         likes l
    INNER JOIN photos p ON l.photo_id = p.id
    INNER JOIN users  u ON p.user_id = u.id
GROUP BY
    l.photo_id,
    u.username
ORDER BY
    likess DESC
FETCH FIRST 1 ROW ONLY;
    
--Q4.Identify and suggest the top 5 most commonly used hashtags on the platform
SELECT * FROM photo_tags,tags;

SELECT
    t.tag_name,
    COUNT(p.photo_id) AS ht
FROM
         photo_tags p
    INNER JOIN tags t ON p.tag_id = t.id
GROUP BY
    t.tag_name
ORDER BY
    ht DESC
FETCH FIRST 5 ROWS ONLY;

--Q5.What day of the week do most users register on? Provide insights on when to schedule an AD campaign
SELECT * FROM users;

SELECT
    TO_CHAR(created_at, 'Day') AS dayy,
    COUNT(username) AS user_count
FROM
    users
GROUP BY
    TO_CHAR(created_at, 'Day')
ORDER BY
    COUNT(username) DESC;
    
--Q6.Provide how many times does average user posts on Instagram. Also, provide the total number of 
--photos on Instagram and total number of users
SELECT * FROM photos,users;

SELECT
    COUNT(p.id)                        AS totalphotos,
    COUNT(DISTINCT u.id)               AS totalusers,
    COUNT(p.id) / COUNT(DISTINCT u.id) AS photos_per_user_ratio
FROM
    users  u
    LEFT JOIN photos p ON u.id = p.user_id;
    
--Q7.Provide data on users (bots) who have liked every single photo on the site (since any normal user would
--not able to do this).
SELECT * FROM users,likes;

SELECT
    u.username,
    COUNT(l.photo_id) AS likess
FROM
         users u
    INNER JOIN likes l ON u.id = l.user_id
GROUP BY
    u.username
HAVING
    COUNT(l.photo_id) = (
        SELECT
            COUNT(*)
        FROM
            photos
    )
ORDER BY
    u.username;
    
