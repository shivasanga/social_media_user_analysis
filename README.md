# Social Media Analysis SQL Project

User analysis is about understanding how users interact with a digital product, such as a software application or mobile app. The goal is to track their behavior, gather data, and derive valuable insights that can benefit various teams in the business.

## project Overview

* **Project Title**: Social Media User Analysis
* **Level**: Beginner
* **Database**: `socialmedia_project_p1`

The Social Media Analysis project aims to provide valuable insights into user behavior on Instagram using Oracle SQL. The analysis focuses on understanding user engagement, identifying inactive users, finding contest winners, and assisting marketing and product teams in their decision-making processes. By exploring Instagram's user data, we derive business insights to improve marketing strategies, app features, and user experience, while also monitoring app performance metrics to detect any anomalies, such as bot accounts.

## Objectives
**The objectives of this project are to:**

1. **Marketing Insights:** Help the marketing team launch effective campaigns by analyzing user behavior and engagement patterns.
2. **User Engagement Metrics:** Provide a detailed analysis of user interactions, post frequency, and the most used hashtags.
3. **Contest Analysis:** Identify the winner of a contest based on likes received on a single post.
4. **Inactive User Identification:** Identify users who have not posted any photos on Instagram.
5. **Bot Detection:** Analyze potential bot accounts by tracking engagement patterns.
6. **Investor Metrics:** Provide data-driven insights into user engagement, ensuring the platform’s continued relevance and growth.

## Project Structure
**The project is organized into the following sections:**

### 1.Database Setup
* **Database Creation:** The project starts by creating a database named `socialmedia_project_p1`
```sql
  Creating User Schema
  CREATE USER C##/*Your Schema Name*/ IDENTIFIED BY /*Your password*/ 
  
  GRANT CONNECT TO C##/*Your Schema Name*/ ;
  
  GRANT RESOURCE TO C##/*Your Schema Name*/
  ALTER USER C##/*Your Schema Name*/ QUOTA unlimited ON USERS;
```
* **Data Extraction:** Extract data from Instagram’s database using SQL queries.

## 2.Data Analysis & Findings
  The follwing SQL queries were developed to answer specific business questions:
  
  ## A.Marketing Insights
  **Q1. Find the 5 oldest users of the Instagram from the database provided**:
  ```sql
      SELECT * FROM users;
      
      SELECT
          username,
          created_at
      FROM
          users
      ORDER BY
          created_at
      FETCH FIRST 5 ROWS ONLY;
  ```
**Q2.Find the users who have never posted a single photo on Instagram**:
  ```sql
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
  ```
  **Q3. Identify the winner of the contest and provide their details to the team**:
  ```sql
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
      FETCH FIRST 1 ROW ONL
```
**Q4. Identify and suggest the top 5 most commonly used hashtags on the platform**:
```sql
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
  ```
  **Q5. What day of the week do most users register on? Provide insights on when to schedule an AD campaign**:
  ```sql
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
   ```
  ## B.Investor Metrics
  **Q6. Provide how many times does average user posts on Instagram. Also, provide the total number of 
        photos on Instagram and total number of users**:
```sql
    SELECT * FROM photos,users;
    
    SELECT
        COUNT(p.id)                        AS totalphotos,
        COUNT(DISTINCT u.id)               AS totalusers,
        COUNT(p.id) / COUNT(DISTINCT u.id) AS photos_per_user_ratio
    FROM
        users  u
        LEFT JOIN photos p ON u.id = p.user_id;
  ```
  **Q7. Provide data on users (bots) who have liked every single photo on the site (since any normal user would
        not able to do this).**:
  ```sql
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
  ```

  # Findings

  ## Marketing Insights
  **1.Loyal Users:** This 5 oldest users on Instagram database.
  ```sql
      Darby_Herzog	    06-MAY-16 12.14.21.191000000 AM
      Emilio_Bernier52	06-MAY-16 01.04.29.960000000 PM
      Elenor88	        08-MAY-16 01.30.40.677000000 AM
      Nicole71	        09-MAY-16 05.30.22.371000000 PM
      Jordyn.Jacobson2	14-MAY-16 07.56.25.835000000 AM
```
**2.Inactive Users:** This are the inactive users on instagram who have never posted a single photo on Instagram.
```sql
    Aniya_Hackett
    Bartholome.Bernhard
    Bethany20
    Darby_Herzog
    David.Osinski47
    Duane60
    Esmeralda.Mraz57
    Esther.Zulauf61
    Franco_Keebler64
    Hulda.Macejkovic
    Jaclyn81
    Janelle.Nikolaus81
    Jessyca_West
    Julien_Schmidt
    Kasandra_Homenick
    Leslie67
    Linnea59
    Maxwell.Halvorson
    Mckenna17
    Mike.Auer39
    Morgan.Kassulke
    Nia_Haag
    Ollie_Ledner37
    Pearl7
    Rocio33
    Tierra.Trantow
```
**3.Contest Winner:** The user with the highest number of likes on a single post is [**Zack_Kemmer93**], with **48** likes.

**4.Hashtag Research:** The top 5 most commonly used hashtags are:
```sql
  smile  	59
  beach	  42
  party	  39
  fun	    38
  concert	24
```
**5.Best Day for Ads:** The most popular day for new user registrations is [**Thursday and Sunday**], suggesting the optimal time to launch an ad campaign.

## Investor Insights
**6.User Engagement:** The average user posts [**2.57**] times on instagram. The total number of photos on Instagram is [**257**], with a total user base of [**100**].

**7. Bot Detection:** We identified **13** accounts that have liked every single photo, suggesting they may be bots or fake accounts.

# Reports
* **Marketing Report:** A detailed analysis for the marketing team covering loyal users, inactive users, contest winner, popular hashtags, and the best days for ads.

* **Investor Report:** A report showcasing user engagement statistics and bot activity detection to assure investors of the platform's relevance and user activity.

# Conclusion
This project provides comprehensive insights into Instagram user behavior, highlighting trends, user engagement, and opportunities for marketing campaigns. By leveraging data analysis, the product and marketing teams can make informed decisions that drive business growth. Additionally, the investor metrics indicate a strong user base with active engagement, while bot detection ensures platform authenticity.

# How to Use
1.**Clone the Repository**: Clone this project repository from GitHub.
2.**Set Up Table Creation**: Run the SQL scripts provided in the `sm_project_dataset.txt` for creating table stracure 
and insert statements 
3.**Run the Queries**: Use SQL queries provided in the `socialmedia_project_p1` file to perform you analysis
4.**Explore and Modify**: Feel free to modify the queries to explore different aspects of the dataset or answer additional
business questions.

# Author - Shiva Sanga
This project is part of my portfolio, showcasing the SQL skills essential for data analyst roles. If you have any questions,
feedback, or would like to collaborate, feel free to get in touch!

* **Linkedin**: [Connect with me professionally](www.linkedin.com/in/shiva-sanga)
