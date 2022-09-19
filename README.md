# Artists_SQL

## Table of Contents
* [Project Overview](#Project-Overview)
* [Resources](#Resources)
* [Background](#Background)
* [Findings](#Findings)

## Project Overview

1. Acquired the discography data of various artists from the Spotify Web API and obtained their corresponding touring/upcoming events data from the Ticketmasters Discovery API.
2. Formatted the acquired data into a relational database and performed exploratory analysis with SQL.
3. Visualized the results as a dashboard using [Tableau](https://public.tableau.com/views/ArtistsDiscographyandEventsDashboard/Dashboard1?:language=en-US&:display_count=n&:origin=viz_share_link)

 
 ![alt text](https://github.com/MSlobody/Artists_SQL/blob/main/Data/Dashboard_Overview.PNG)

## Resources
Python Version: 3.9.7\
Packages: numpy, pandas,spotipy, urllib3. See requirements.txt.\
Spotify Web API: https://developer.spotify.com/  \
Spotipy Documentation: https://spotipy.readthedocs.io/en/master/ \
Ticketmaster Discovery API: https://developer.ticketmaster.com/products-and-docs/apis/discovery-api/v2/  \
DB Browser for SQLite (Version 3.11.2): https://sqlitebrowser.org/. Required to run “2_SQL_Exploratory_Analysis.sql”. \
Tableau Public: https://public.tableau.com/app/discover

## Background

Spotify has approximately 433 million users, storing more than 50 million songs at our fingertips. An albums popularity on Spotify is closely linked with the success of that album commercially, contributing a large portion of the album-equivalent units reported by the music industry. This popularity is reported as a score out of 100, based on the combination of total number of plays and how recent those plays are.  

With this vast amount of data provided by Spotify I focused on the discography of my 10 favourite artists to identify: how frequently on average a new album is released for each artist, which albums are the most popular and who has the richest discography. Additionally, I examined the upcoming touring information of my favourite artists using Ticketmaster to identify the cities that have the most events. 

Note in this project I consider an Extended Play (EP) and live sessions designated as an album on spotify as albums. 

## Findings

#### Summary:

- Ed Sheeran has more than double the number of followers of the second most followed artist, The Weeknd. However, based on the popularity metric Ed Sheeran is less popular than the Weeknd and is equally as popular as Kanye West. The least popular artist with the least number of followers happens to be Arkells, which makes sense given that they are a local Canadian alternative rock band. 

- Kanye West has the richest discography with 12 albums and 185 tracks. Surprisingly, Dua Lipa with only 3 albums has the fourth highest number of followers and popularity which indicates how commercially successful her discography is. 

 ![alt text](https://github.com/MSlobody/Artists_SQL/blob/main/Data/Summary_table.PNG)

#### Average Time Between an Album Release:

Amongst my top 10 artists I was curious how frequently each artist releases a new album. Each artist is at a different stage in their career, releasing music at a different pace. In this dataset alone the number of albums ranges from 3, released by Dua Lipa, to 12, released by Kanye West.  

-	On average it takes 904 days for Arctic Monkeys to release a new album, which is the longest time of any artist in my list. This is partly due to the long break they took from the release of AM to Tranquility Base Hotel & Casino of nearly 5 years. 
-	The Weeknd, H.E.R. and Ed Sheeran on average require 438 days, 436 days, and 411 days, respectively to release a new album.  With the most followers and highest popularity, the Weeknd and Ed Sheeran produce new content for their fans at an incredibly fast pace. 

 ![alt text](https://github.com/MSlobody/Artists_SQL/blob/main/Data/Avg_time_between_albums.PNG)

 #### Artists Album Popularity:
I found that despite the bias towards more recent plays by the popularity algorithm, the most popular albums are not always the most recent. A few examples:
-	The album “AM” by Arctic Monkeys released in 2013 is the most popular out of their entire discography. 
-	The album “I Used To Know Her” by H.E.R. released in 2019 is the most popular in her discography, beating the more recent "Back of My Mind".
-	Kanye West’s “Graduation” from 2007 is still his most popular album, despite 8 new albums being released since then. 

![alt text](https://github.com/MSlobody/Artists_SQL/blob/main/Data/Album_popularity.PNG)


#### Artist Performances Across the Globe:
If many artists are performing in the same city this would encourage me to travel to attend their shows. From the Ticketmaster data it appears that Toronto and Amsterdam have the most events with 6 upcoming shows. Post Malone, Kid Cudi, The Weeknd and NIKI will all be performing in my hometown of Toronto. Other cities such as Brisbane in Australia only have one event, a performance by the Arctic Monkeys on the 11th of January 2023. As a result, I will likely stay in Toronto to attend my favourite artist performances!

 ![alt text](https://github.com/MSlobody/Artists_SQL/blob/main/Data/Artist_performances.PNG)
 

