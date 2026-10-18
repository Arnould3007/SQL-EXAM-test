# Mock Exam — SQL & Dashboards (Streaming Platform)

**Duration:** 2 hours. **Database:** PostgreSQL 16+ (`sql_course`). **Tools:** DBeaver, Tableau Public, Git.

This is a practice exam. It follows the same workflow as the real exam:

```text
1. Download this public repository
2. Prepare the database and solve the questions
3. Upload your work to YOUR OWN public repository
4. Send the link of your repository by email
```

---

## Part 0 — Setup (10 min)

1. Clone this repository on your computer.
2. In DBeaver, connect to your `sql_course` database.
3. Open `setup/exam_preparation.sql` and run the **entire script** (Alt+X).
   The last query must return: `10, 7, 5, 10, 30, 5, 11`.
4. Copy `answers_template.sql` to a new file called **`answers.sql`** at the root of the repository.
   Write all your answers in `answers.sql`.

All tables are in the schema `exam_practice`. Start your answer file with:

```sql
SET search_path TO exam_practice;
```

### Data model

| Table | One row = | Main columns |
|---|---|---|
| `users` | one user | user_id (PK), username, country, signup_date, referred_by (FK users) |
| `subscriptions` | the subscription of one user | user_id (PK, FK users), plan_name, monthly_price, start_date |
| `artists` | one artist | artist_id (PK), artist_name, genre |
| `tracks` | one track | track_id (PK), artist_id (FK), title, duration_sec, release_year |
| `plays` | one listening event | play_id (PK), user_id (FK), track_id (FK), played_at, seconds_listened |
| `playlists` | one playlist | playlist_id (PK), user_id (FK), playlist_name |
| `playlist_tracks` | one track inside one playlist | playlist_id, track_id (composite PK) |

---

## Part 1 — SQL questions (80 min)

For **each** question, paste in `answers.sql`:
- your final query;
- the answer, as a comment: the number of rows and the key values (or the first rows if the result is long).

### Q1 — 
List the tracks released in **2025 or later** that last **less than 4 minutes**.
Return `title`, `release_year`, `duration_sec`, from the shortest to the longest.

### Q2 — 
Return the users who have **at least 3 plays**.
Return `user_id`, `nb_plays`, sorted by `nb_plays` descending.

### Q3 — 
Total listening time (`seconds_listened`) **per country**.
Users without a country must appear under the label `'Unknown'`.
Return `country`, `total_seconds`, sorted by `total_seconds` descending.

### Q4 — 
Return **every playlist** with its number of tracks, **including empty playlists**.
Return `playlist_name`, `nb_tracks`.

### Q5 —
Classify each play as `'full'` if the user listened to the whole track
(`seconds_listened = duration_sec`), otherwise `'partial'`.
Then return the number of plays in each category: `listen_type`, `nb_plays`.

### Q6 — 
Return the tracks that have **never been added to any playlist**.
Return `track_id`, `title`. Use a subquery.

### Q7 —
Return the users whose **total listening time** is above the **average total listening time of all users**.
Users who never listened count as **0**.
Return `user_id`, `username`, `total_seconds`, sorted descending.
Use named CTEs.

### Q8 — 
For each user, return their **longest single play** (highest `seconds_listened`).
Return `user_id`, `play_id`, `played_at`, `seconds_listened`.

### Q9 — 
For each month: total `seconds_listened`, the previous month's total, and the
month-over-month change in % (rounded to 2 decimals).
Return `month`, `total_seconds`, `previous_month_seconds`, `mom_pct`.

### Q10 — 
Rank the **genres** by total listening time (1 = highest), using `DENSE_RANK`.
Return `genre`, `total_seconds`, `genre_rank`.

### Q11 — 
A colleague wrote this query to show **every user with their number of plays,
including users who never listened**. It returns a wrong result.

```sql
SELECT u.username, COUNT(*) AS nb_plays
FROM users AS u
JOIN plays AS p ON u.user_id = p.user_id
GROUP BY u.username;
```

In `answers.sql`: explain **every** problem in one or two sentences, then write the corrected query.

---

## Part 2 — Tableau (25 min)

1. In DBeaver, export the tables `users`, `plays` and `tracks` to CSV
   (right-click on the table → Export Data → CSV, header on top).
   Save them in a folder `tableau/` in your repository.
2. In Tableau Public, load the 3 CSV files and create the relationships:
   `plays.user_id = users.user_id` and `plays.track_id = tracks.track_id`.
3. Build **two worksheets**:
   - total listening time **per country** (bar chart, sorted);
   - number of plays **per month** (line chart).
4. Combine them in a **dashboard** with a clear business title.
5. Save locally as **`tableau/dashboard.twbx`** (packaged workbook).
6. Take a **screenshot** of the final dashboard: **`tableau/dashboard.png`**.

---

## Part 3 — Submission (5 min)

1. Your repository must contain:
   ```text
   answers.sql
   tableau/dashboard.twbx
   tableau/dashboard.png
   tableau/*.csv
   ```
2. Push everything to **your own public repository** (new or reused from the last exam).
3. Send the **link of your repository** by email.

**Important:** only the **last commit of the `main` (or `master`) branch** will be reviewed.
Check on GitHub that your files are there before sending the email.
