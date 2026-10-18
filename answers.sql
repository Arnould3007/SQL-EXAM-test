-- ============================================================
-- MOCK EXAM — ANSWERS
-- Name: Arnould
--
-- Copy this file as answers.sql and fill it in.
-- For each question: your final query + the answer as a comment.
-- ============================================================

SET search_path TO exam_practice;


-- Q1 :List the tracks released in **2025 or later** that last **less than 4 minutes**.
-- Return `title`, `release_year`, `duration_sec`, from the shortest to the longest.
-- Query:
select title, release_year, duration_sec
from tracks
where release_year >= 2025
and duration_sec < 240
order by duration_sec asc;
-- Answer (rows + key values):
-- Corner Store (2025, 165) / City Lights (2025, 185) / No Signal (2026, 190) / Northbound (2025, 200)

-- Q2 Return the users who have **at least 3 plays**.
-- Return `user_id`, `nb_plays`, sorted by `nb_plays` descending.
-- Query:
select u.user_id, count(play_id) as nb_plays
from users as u
left join plays as p
on u.user_id = p.user_id
group by u.user_id
having count(play_id) >= 3
order by nb_plays desc
-- Answer:
-- 7 rows : (User 1 = 7), (User 2 = 5), (User 3 = 4), (User 6,5,7,4 = 3)

-- Q3 Total listening time (`seconds_listened`) **per country**.
--Users without a country must appear under the label `'Unknown'`.
--Return `country`, `total_seconds`, sorted by `total_seconds` descending
-- Query:
select coalesce(u.country, 'Unknown'),sum(seconds_listened) as total_seconds 
from users as u
join plays as p
on u.user_id = p.user_id
group by u.country
order by total_seconds desc;
-- Answer:
-- 4 rows : (Spain = 2645) / (France = 2140) / (Italy= 1425) / (Unkown = 375)

-- Q4 Return **every playlist** with its number of tracks, **including empty playlists**.
-- Return `playlist_name`, `nb_tracks`
-- Query:
select playlist_name, count(t.track_id) as nb_tracks
from playlists as p
left join playlist_tracks as pt
on p.playlist_id = pt.playlist_id
left join tracks as t
on pt.track_id = t.track_id
group by p.playlist_name
-- Answer:
--5 rows => (3 tracks for first 3, 2 for Old favourites, 0 for to fill later)

-- Q5 Classify each play as `'full'` if the user listened to the whole track
--(`seconds_listened = duration_sec`), otherwise `'partial'`.
--Then return the number of plays in each category: `listen_type`, `nb_plays`
-- Query:
with listen_type as(
					select )
select listen_type, as count(play_id) as nb_plays
from plays as p
join tracks as t
on p.track_id = t.track_id
where listen_type in (
					select p.second_listened, t.duration_sec
					from
					where p.second_listened = t.duration_sec ) as full 
group by listen_type 
-- Answer:


-- Q6 Return the tracks that have **never been added to any playlist**.
--Return `track_id`, `title`. Use a subquery
-- Query:

SELECT t.track_id, t.title
FROM tracks AS t
left JOIN playlist_tracks AS pt
    ON t.track_id = pt.track_id
WHERE pt.track_id IS NULL;
-- Answer:
-- 1 row, No Signal 9th track

-- Q7 Return the users whose **total listening time** is above the **average total listening time of all users**.
--Users who never listened count as **0**.
--Return `user_id`, `username`, `total_seconds`, sorted descending.
--Use named CTEs.
-- Query:

WITH user_totals AS (
    -- one row = one user (all 10), 0 if no plays
    SELECT u.user_id,
           u.username,
           COALESCE(SUM(p.seconds_listened), 0) AS total_seconds
    FROM users AS u
    LEFT JOIN plays AS p ON u.user_id = p.user_id
    GROUP BY u.user_id, u.username
),
average_total AS (
    -- one single value: average of the 10 totals
    SELECT AVG(total_seconds) AS avg_total
    FROM user_totals
)
SELECT ut.user_id, ut.username, ut.total_seconds
FROM user_totals AS ut, average_total AS a
WHERE ut.total_seconds > a.avg_total
ORDER BY ut.total_seconds DESC;
-- Answer:
-- 4 rows => user_id 1,2,3 and 7 with 1570, 1250, 940, 770

-- Q8 For each user, return their **longest single play** (highest `seconds_listened`).
-- Return `user_id`, `play_id`, `played_at`, `seconds_listened`.
-- Query:
WITH with_max AS (
    SELECT user_id, play_id, played_at, seconds_listened,
           MAX(seconds_listened) OVER (PARTITION BY user_id) AS user_max
    FROM plays
)
SELECT user_id, play_id, played_at, seconds_listened
FROM with_max
WHERE seconds_listened = user_max
ORDER BY user_id;
-- Answer:


-- Q9 For each month: total `seconds_listened`, the previous month's total, and the
-- month-over-month change in % (rounded to 2 decimals).
-- Return `month`, `total_seconds`, `previous_month_seconds`, `mom_pct`.
-- Query:
with monthly as (
				select DATE_TRUNC('month', played_at)::date AS month, 
				sum(seconds_listened) as total_seconds	
				from plays
				group by month),
prev_month as (
			   select month, total_seconds, lag (total_seconds) over (order by month) as previous_month_seconds 
			   from monthly)
select month, total_seconds, previous_month_seconds,
	   ROUND((100.0*total_seconds - previous_month_seconds)
             / NULLIF(previous_month_seconds, 0) * 100, 2) AS mom_growth_pct
from prev_month
order by month;
-- Answer:

-- Q10 Rank the **genres** by total listening time (1 = highest), using `DENSE_RANK`.
-- Return `genre`, `total_seconds`, `genre_rank`
-- Query:
SELECT a.genre,
       SUM(p.seconds_listened) AS total_seconds,
       DENSE_RANK() OVER (ORDER BY SUM(p.seconds_listened) DESC) AS genre_rank
FROM plays AS p
JOIN tracks AS t  ON p.track_id = t.track_id
JOIN artists AS a ON t.artist_id = a.artist_id
GROUP BY a.genre
ORDER BY genre_rank;
-- Answer: 5 rows
-- 1 Electro 2310 / 2 Pop 1755 / 3 Rap 1000 / 4 Jazz 960 / 5 Indie 560
-- Answer:


-- Q11 A colleague wrote this query to show **every user with their number of plays,
-- including users who never listened**. It returns a wrong result
SELECT u.username, COUNT(*) AS nb_plays
FROM users AS u
JOIN plays AS p ON u.user_id = p.user_id
GROUP BY u.username;
-- Problems found:

-- Corrected query:
SELECT u.username, COUNT(p.play_id) AS nb_plays
FROM users AS u
left JOIN plays AS p ON u.user_id = p.user_id
--where u.user_id is null
GROUP BY u.username
ORDER BY nb_plays DESC;
