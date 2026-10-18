-- ============================================================
-- MOCK EXAM - DATABASE PREPARATION (STREAMING PLATFORM)
--
-- Run the ENTIRE script once, connected to the sql_course database.
-- It creates its own schema "exam_practice" and does not touch other schemas.
-- WARNING: running it again drops and recreates exam_practice.
--
-- Model (grain)
--   users            one row = one user of the app
--   subscriptions    one row = the subscription of one user     (users 1:1 subscriptions)
--   artists          one row = one artist
--   tracks           one row = one track                        (artists 1:N tracks)
--   plays            one row = one listening event of a track   (users 1:N plays, tracks 1:N plays)
--   playlists        one row = one playlist                     (users 1:N playlists)
--   playlist_tracks  one row = one track inside one playlist    (bridge table, playlists N:M tracks)
-- ============================================================

DROP SCHEMA IF EXISTS exam_practice CASCADE;
CREATE SCHEMA exam_practice;
SET search_path TO exam_practice;

CREATE TABLE users (
    user_id     INTEGER PRIMARY KEY,
    username    VARCHAR(50) NOT NULL UNIQUE,
    country     VARCHAR(50),
    signup_date DATE NOT NULL,
    referred_by INTEGER REFERENCES users(user_id)
);

CREATE TABLE subscriptions (
    user_id       INTEGER PRIMARY KEY REFERENCES users(user_id),
    plan_name     VARCHAR(20) NOT NULL CHECK (plan_name IN ('free', 'premium', 'family')),
    monthly_price NUMERIC(6, 2) NOT NULL CHECK (monthly_price >= 0),
    start_date    DATE NOT NULL
);

CREATE TABLE artists (
    artist_id   INTEGER PRIMARY KEY,
    artist_name VARCHAR(100) NOT NULL,
    genre       VARCHAR(30) NOT NULL
);

CREATE TABLE tracks (
    track_id     INTEGER PRIMARY KEY,
    artist_id    INTEGER NOT NULL REFERENCES artists(artist_id),
    title        VARCHAR(100) NOT NULL,
    duration_sec INTEGER NOT NULL CHECK (duration_sec > 0),
    release_year INTEGER NOT NULL
);

CREATE TABLE plays (
    play_id          INTEGER PRIMARY KEY,
    user_id          INTEGER NOT NULL REFERENCES users(user_id),
    track_id         INTEGER NOT NULL REFERENCES tracks(track_id),
    played_at        DATE NOT NULL,
    seconds_listened INTEGER NOT NULL CHECK (seconds_listened >= 0)
);

CREATE TABLE playlists (
    playlist_id   INTEGER PRIMARY KEY,
    user_id       INTEGER NOT NULL REFERENCES users(user_id),
    playlist_name VARCHAR(100) NOT NULL
);

CREATE TABLE playlist_tracks (
    playlist_id INTEGER NOT NULL REFERENCES playlists(playlist_id),
    track_id    INTEGER NOT NULL REFERENCES tracks(track_id),
    PRIMARY KEY (playlist_id, track_id)
);

INSERT INTO users (user_id, username, country, signup_date, referred_by)
VALUES
    (1,  'lea',  'France', '2025-11-03', NULL),
    (2,  'tom',  'Spain',  '2025-11-20', 1),
    (3,  'nina', 'Spain',  '2025-12-05', 1),
    (4,  'omar', 'Italy',  '2026-01-10', 2),
    (5,  'ines', 'France', '2026-01-22', NULL),
    (6,  'paul', 'Spain',  '2026-02-14', 3),
    (7,  'sara', 'Italy',  '2026-03-01', NULL),
    (8,  'yuki', NULL,     '2026-03-18', 5),
    (9,  'ben',  'France', '2026-04-02', NULL),
    (10, 'eva',  'Spain',  '2026-05-09', 6);

INSERT INTO subscriptions (user_id, plan_name, monthly_price, start_date)
VALUES
    (1, 'premium', 10.99, '2025-11-03'),
    (2, 'premium', 10.99, '2025-12-01'),
    (3, 'family',  16.99, '2025-12-05'),
    (4, 'free',     0.00, '2026-01-10'),
    (5, 'premium', 10.99, '2026-02-01'),
    (6, 'free',     0.00, '2026-02-14'),
    (7, 'family',  16.99, '2026-03-01');

INSERT INTO artists (artist_id, artist_name, genre)
VALUES
    (1, 'Nova Lane',       'Pop'),
    (2, 'The Quiet Hours', 'Indie'),
    (3, 'DJ Sol',          'Electro'),
    (4, 'Mara Blue',       'Jazz'),
    (5, 'Kilo Kid',        'Rap');

INSERT INTO tracks (track_id, artist_id, title, duration_sec, release_year)
VALUES
    (1,  1, 'Paper Moon',    210, 2024),
    (2,  1, 'City Lights',   185, 2025),
    (3,  2, 'Slow Tide',     240, 2023),
    (4,  2, 'Northbound',    200, 2025),
    (5,  3, 'Sunrise Drive', 300, 2025),
    (6,  3, 'Neon Rain',     270, 2026),
    (7,  4, 'Blue Hour',     320, 2022),
    (8,  5, 'Corner Store',  165, 2025),
    (9,  5, 'No Signal',     190, 2026),
    (10, 4, 'Late Train',    280, 2026);

INSERT INTO plays (play_id, user_id, track_id, played_at, seconds_listened)
VALUES
    (1,  1, 1, '2026-01-05', 210),
    (2,  1, 2, '2026-01-12', 185),
    (3,  2, 5, '2026-01-15', 300),
    (4,  3, 3, '2026-01-20', 120),
    (5,  4, 8, '2026-01-28', 165),
    (6,  1, 1, '2026-02-02', 210),
    (7,  2, 6, '2026-02-08', 270),
    (8,  3, 7, '2026-02-11', 320),
    (9,  5, 2, '2026-02-17',  90),
    (10, 4, 9, '2026-02-25', 190),
    (11, 1, 5, '2026-03-03', 300),
    (12, 2, 5, '2026-03-09', 300),
    (13, 6, 8, '2026-03-12', 165),
    (14, 3, 4, '2026-03-18', 200),
    (15, 7, 7, '2026-03-22', 320),
    (16, 5, 1, '2026-03-30', 210),
    (17, 1, 6, '2026-04-04', 270),
    (18, 2, 1, '2026-04-10',  60),
    (19, 6, 9, '2026-04-15', 190),
    (20, 7, 3, '2026-04-21', 240),
    (21, 8, 2, '2026-04-27', 185),
    (22, 1, 1, '2026-05-02', 210),
    (23, 3, 5, '2026-05-08', 300),
    (24, 5, 6, '2026-05-14', 270),
    (25, 6, 8, '2026-05-19', 100),
    (26, 8, 9, '2026-05-25', 190),
    (27, 1, 2, '2026-06-01', 185),
    (28, 2, 7, '2026-06-06', 320),
    (29, 4, 5, '2026-06-12', 300),
    (30, 7, 1, '2026-06-18', 210);

INSERT INTO playlists (playlist_id, user_id, playlist_name)
VALUES
    (1, 1, 'Morning Run'),
    (2, 2, 'Focus'),
    (3, 3, 'Chill Sunday'),
    (4, 1, 'Old Favourites'),
    (5, 5, 'To Fill Later');

INSERT INTO playlist_tracks (playlist_id, track_id)
VALUES
    (1, 5), (1, 6), (1, 8),
    (2, 3), (2, 4), (2, 7),
    (3, 3), (3, 7), (3, 10),
    (4, 1), (4, 2);

-- ============================================================
-- VERIFICATION (expected: 10, 7, 5, 10, 30, 5, 11)
-- ============================================================

SELECT
    (SELECT COUNT(*) FROM users)           AS users,
    (SELECT COUNT(*) FROM subscriptions)   AS subscriptions,
    (SELECT COUNT(*) FROM artists)         AS artists,
    (SELECT COUNT(*) FROM tracks)          AS tracks,
    (SELECT COUNT(*) FROM plays)           AS plays,
    (SELECT COUNT(*) FROM playlists)       AS playlists,
    (SELECT COUNT(*) FROM playlist_tracks) AS playlist_tracks;
