
-- PART 1) Filtering the Albums and Tracks tables to extract unique entries. 
 
-- Artists often release multiple versions of the same album, changing the order of songs or an artist decides to re-issue an album from when they were on a different label.
-- Artists also release extended, explicit or remixed versions of their albums. 
-- Lets remove these versions of the same album by selecting for the most popular one. 
DROP Table if exists Unique_Albums;
Create Table Unique_Albums (
    id INTEGER PRIMARY KEY,
    artist_id NUMERIC,
    album_name nvarchar(255),
    shortened_album_name nvarchar(255),
    total_tracks NUMERIC,
    label nvarchar(255),
    release_date DATETIME,
    popularity NUMERIC 
);

-- To filter out different versions of the same album, I extract the portion of the album name before the brackets () 
-- and group albums by this common shared name filtering for the most popular one 
Insert into Unique_Albums
SELECT id, artist_id, album_name, 
 CASE
    WHEN album_name LIKE '%(%' THEN SUBSTR(album_name, 0,INSTR(album_name,"(")-1)
    ELSE album_name
END AS shortened_album_name,
total_tracks, label, release_date,
MAX(popularity) as popularity
FROM Albums
GROUP BY LOWER(shortened_album_name)
ORDER BY id;

SELECT *
FROM Unique_Albums



-- lets now filter for the relevant tracks, removing previous duplicates.  
DROP Table if exists Unique_Tracks;
Create Table Unique_Tracks (
    id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,
    album_id INTEGER,
    artist_id INTEGER,
    track_name TEXT,
    popularity INTEGER,
    duration_ms INTEGER,
    track_number INTEGER,
    disc_number INTEGER,
    explicit BOOL,
    danceability FLOAT,
    energy FLOAT,
    key INTEGER,
    loudness FLOAT,
    mode INTEGER,
    speechiness FLOAT,
    acousticness FLOAT,
    instrumentalness FLOAT,
    liveness FLOAT,
    valence FLOAT,
    tempo FLOAT,
    time_signature INTEGER
);

Insert into Unique_Tracks
SELECT Tr.*
FROM Tracks Tr 
JOIN Unique_Albums Uniq_Al ON Tr.album_id = Uniq_Al.id
ORDER BY Tr.id;

SELECT *
FROM Unique_Tracks




-- PART 2) Exploratory analysis of artists, albums and tracks.  

-- What is the length of an album? Combine the Unique_Tracks and Unique_Albums tables and sum the track lengths within an album
SELECT Uniq_Al.album_name, Uniq_Al.total_tracks,
TIME(SUM(Uniq_Tr.duration_ms)/1000,'unixepoch') AS album_length
FROM Unique_Tracks Uniq_Tr
JOIN Unique_Albums Uniq_Al ON Uniq_Tr.album_id = Uniq_Al.id
GROUP BY Uniq_Al.id

-- Album popularity. What is the popularity of each artists albums?  Are more recent albums more popular or less?
SELECT Art.artist_name, Uniq_Al.album_name, Uniq_Al.popularity, Uniq_Al.release_date
FROM Unique_Albums Uniq_Al
JOIN Artists Art ON Uniq_Al.artist_id = Art.id
ORDER BY Art.artist_name, Uniq_Al.release_date DESC


-- Lets find the average duration in days that it takes for an artist to release a new album.
-- First, find the difference between album release dates using the lag() window function. 
WITH Album_Release AS
(SELECT artist_id,
JulianDay(release_date) - JulianDay(LAG(release_date) OVER (PARTITION BY artist_id ORDER BY release_date ASC)) AS days_between_albums
FROM Unique_Albums)
 
SELECT Art.artist_name,
ROUND(AVG(Al_Rel.days_between_albums),1) AS average_days_between_albums
FROM Album_Release Al_Rel
JOIN Artists Art ON Al_Rel.artist_id = Art.id
GROUP BY Al_Rel.artist_id 
ORDER BY average_days_between_albums DESC


-- Merge all 3 tables to generate a summary of each artist.  
SELECT Art.artist_name, Art.followers, Art.popularity, 
COUNT(DISTINCT(Uniq_Al.id)) AS album_count,
COUNT(DISTINCT(Uniq_Tr.id)) AS track_count
FROM Artists Art
INNER JOIN Unique_Albums Uniq_Al ON Art.id = Uniq_Al.artist_id 
INNER JOIN Unique_Tracks Uniq_Tr ON Uniq_Al.id = Uniq_Tr.album_id
GROUP BY Art.id
ORDER BY Art.followers DESC


-- For each track find the percentage of the album that has been played, if listening to the album sequentially.  
WITH Album_Percentage AS (
SELECT *, 
CAST(SUM(duration_ms) OVER (PARTITION BY album_id ORDER BY id) AS FLOAT) AS cumulative_duration,
CAST(SUM(duration_ms) OVER (PARTITION BY album_id) AS FLOAT) AS total_duration
FROM Unique_Tracks)

SELECT Uniq_Al.album_name, Al_Perc.track_name, Al_Perc.popularity, Al_Perc.disc_number, Al_Perc.track_number,
TIME(Al_Perc.duration_ms/1000,'unixepoch') AS track_length,
ROUND(Al_Perc.cumulative_duration / (Al_Perc.total_duration) * 100,2) AS album_completion_percentage
FROM Album_Percentage Al_Perc
JOIN Unique_Albums Uniq_Al ON Al_Perc.album_id = Uniq_Al.id




-- PART 3) Lets create a map of events being hosted by our 10 selected artists. 

-- extract the relevant venue information for each event. 
SELECT Art.artist_name,Eve.event_name, Eve.venue_name, Eve.venue_country, Eve.venue_country_code,
Eve.venue_city, Eve.venue_address, Eve.venue_location_latitude,Eve.venue_location_longitude,
Eve.event_DateTime
FROM Events Eve
JOIN Artists Art ON Eve.artist_id = Art.id

-- Identify the cities with the most events. 
SELECT venue_country, venue_city, venue_location_latitude, venue_location_longitude,
COUNT(event_name) AS event_count
FROM Events
GROUP BY venue_city
ORDER BY event_count DESC
