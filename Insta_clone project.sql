

use ig_clone;


show tables;

#Task Questions:

-- 1.Find the 5 oldest users.


select * from users order by created_at  limit 5 ;


select created_At,count(*) as freq from users group by created_at order by freq desc;


--  2.What day of the week do most users register on? We need to figure out when to schedule an ad campaign.


with cte_1 as (select *, CASE weekday(created_at) 
                               WHEN 0 then "Monday"
                               WHEN 1 then "Tuesday"
                               WHEN 2 then "wednesday"
                               WHEN 3 then "Thursday"
                               WHEN 5 then "Friday"
                               WHEN 6 then "Saturday"
                               WHEN 7 then "Sunday" END as weekday_cat from users)
            select weekday_cat as weekday,count(weekday_cat) as cont from cte_1
                group by weekday_cat order by cont desc;





-- 3.We want to target our inactive users with an email campaign.Find the users who have never posted a photo.


select u.username from users u left join photos p on u.id = p.id 
left join photo_tags pt on p.id = pt.photo_id 
where pt.photo_id is null;

-- 4.We're running a new contest to see who can get the most likes on a single photo.WHO WON??!!

select * from likes;

SELECT l.photo_id,COUNT(*) AS Total_Likes
FROM likes l
JOIN photos p ON p.id = l.photo_id
JOIN users u ON u.id = l.user_id
GROUP BY l.photo_id
ORDER BY Total_Likes desc
limit 1;


-- 5.Our Investors want to know… How many times does the average user post?HINT - *total number of photos/total number of users*





with cte_1 as (select count(image_url) as photos_count from photos) ,
cte_2 as (select count(username) as users_count from users)

select cte_1.photos_count/cte_2.users_count as avg_user_post from cte_1,cte_2;


-- 6.user ranking by postings higher to lower.

SELECT 
    u.username, COUNT(*) AS freq
FROM
    users u
        JOIN
    photos p ON u.id = p.user_id
GROUP BY u.username
ORDER BY freq DESC;





-- 7.total numbers of users who have posted at least one time.

select * from photos;

SELECT 
		count(distinct username) as users_posted_atleast_onetime
FROM
    users u
        LEFT JOIN
    photos p ON u.id = p.user_id
WHERE
    image_url IS NOT NULL;






/*-- 8.A brand wants to know which hashtags to use in a post
What are the top 5 most commonly used hashtags?*/


SELECT 
    t.tag_name, COUNT(t.tag_name) AS freq
FROM
    photo_tags pt
         JOIN
    tags t ON pt.tag_id = t.id
GROUP BY t.id
ORDER BY freq DESC
LIMIT 5;








-- 9.We have a small problem with bots on our site...Find users who have liked every single photo on the site.


select * from likes;
select * from users;
select count(*) from photos;

SELECT 
    u.id, username, COUNT(*) AS freq
FROM
    likes l
        JOIN
    users u ON l.user_id = u.id
GROUP BY u.id
HAVING freq = (SELECT 
        COUNT(*)
    FROM
        photos);





-- 10.Find users who have never commented on a photo.

SELECT 
    u.username
FROM
    users u
        LEFT JOIN
    comments c ON u.id = c.user_id
WHERE
    c.comment_text IS NULL;


