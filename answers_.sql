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
where release_year >= '2025'
and duration_sec < 240
order by duration_sec asc;
-- Answer (rows + key values):
4 rows for 3 columns => row one = Corner Store / 2025 / 165

-- Q2
-- Query:

-- Answer:


-- Q3
-- Query:

-- Answer:


-- Q4
-- Query:

-- Answer:


-- Q5
-- Query:

-- Answer:


-- Q6
-- Query:

-- Answer:


-- Q7
-- Query:

-- Answer:


-- Q8
-- Query:

-- Answer:


-- Q9
-- Query:

-- Answer:


-- Q10
-- Query:

-- Answer:


-- Q11
-- Problems found:

-- Corrected query:

