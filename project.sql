create database project;

use project;

CREATE TABLE games (
  `gameID`  int(5) ,
  `leagueID`  int(5),
  `season`  int(5) ,
  `date` VARCHAR(20) ,
  `homeTeamID` int(5) ,
  `awayTeamID` int(5) ,
  `homeGoals` int(5) ,
  `awayGoals` int(5) ,
  `homeProbability` float(5),
  `drawProbability` float(5) ,
  `awayProbability` float(5) 
) ;

CREATE TABLE appearances (
	gameID int(5) , 
    playerID int(5) , 
    goals int(5) ,
    shots int(5) ,
    leagueID int(5)
);

CREATE TABLE player (
	playerID int(5) ,
    `name` VARCHAR(50)
); 

CREATE TABLE shots (
	gameID int(5) ,
    shooterID int(5) , 
    assisterID VARCHAR(5) , 
    shotType VARCHAR(20),
    shotResult VARCHAR(20)
) ;

/*QUESTION 1*/
/*For games, find the average homeGoals and awayGoals, which one is higher?*/

SELECT AVG(homeGoals)
FROM games;

SELECT AVG(awayGoals)
FROM games;

/*QUESTION 2*/
/*Find the top 5 games with most shots by team Chelsea*/

SELECT *
FROM teamstats
LEFT JOIN TEAMS
ON teamstats.teamID = teams.teamID
WHERE name = 'Chelsea'
ORDER BY shots DESC LIMIT 5;

/*QUESTION 3*/
/*For shots, find the most preferred shotType*/

SELECT COUNT(*), shotType
FROM shots
GROUP BY shotType
ORDER BY COUNT(*) DESC;

/*QUESTION 4*/
/*List the top 10 scorers (scored in single game) with their name and league name, which league has the most?*/

SELECT player.playerID, player.name, goals, leagues.name
FROM appearances LEFT JOIN player
ON  appearances.playerID = player.playerID
LEFT JOIN leagues
ON leagues.leagueID = appearances.leagueID
ORDER BY goals DESC LIMIT 10;

/*QUESTION 5*/
/*Find teams with  the name which has the top 10 most shots.*/

SELECT teamstats.teamID, teams.name, SUM(shots) AS total_shots
FROM teamstats LEFT JOIN teams
ON teamstats.teamID = teams.teamID
GROUP BY teamstats.teamID, teams.name
ORDER BY total_shots DESC LIMIT 10;teamstatsteamstats

/*QUESTION 6*/
/*List the team name that has the lowest/highest shot in season 2017, 2018, 2020.*/

SELECT teamstats.teamID, teams.name, SUM(shots) AS total_shots, season
FROM teamstats LEFT JOIN teams
ON teamstats.teamID = teams.teamID
WHERE season = 2017
GROUP BY teamstats.teamID, teams.name
ORDER BY total_shots LIMIT 1;

SELECT teamstats.teamID, teams.name, SUM(shots) AS total_shots, season
FROM teamstats LEFT JOIN teams
ON teamstats.teamID = teams.teamID
WHERE season = 2017
GROUP BY teamstats.teamID, teams.name
ORDER BY total_shots DESC LIMIT 1;

SELECT teamstats.teamID, teams.name, SUM(shots) AS total_shots, season
FROM teamstats LEFT JOIN teams
ON teamstats.teamID = teams.teamID
WHERE season = 2018
GROUP BY teamstats.teamID, teams.name
ORDER BY total_shots LIMIT 1;

SELECT teamstats.teamID, teams.name, SUM(shots) AS total_shots, season
FROM teamstats LEFT JOIN teams
ON teamstats.teamID = teams.teamID
WHERE season = 2018
GROUP BY teamstats.teamID, teams.name
ORDER BY total_shots DESC LIMIT 1;

SELECT teamstats.teamID, teams.name, SUM(shots) AS total_shots, season
FROM teamstats LEFT JOIN teams
ON teamstats.teamID = teams.teamID
WHERE season = 2020
GROUP BY teamstats.teamID, teams.name
ORDER BY total_shots LIMIT 1;

SELECT teamstats.teamID, teams.name, SUM(shots) AS total_shots, season
FROM teamstats LEFT JOIN teams
ON teamstats.teamID = teams.teamID
WHERE season = 2020
GROUP BY teamstats.teamID, teams.name
ORDER BY total_shots DESC LIMIT 1;

/*QUESTION 7*/
/*How many matches does the top 3 scorers(scored in all games)  have in all seasons?*/

SELECT appearances.playerID, one.total_goals, COUNT(appearances.playerID) AS num_of_matches
FROM appearances
JOIN
	(SELECT playerID, sum(goals) AS total_goals
	FROM appearances
	GROUP BY playerID
	ORDER BY total_goals DESC LIMIT 3) ONE
	ON appearances.playerID = one.playerID
GROUP BY appearances.playerID;

/*QUESTION 8*/
/*Top team that has the highest goal*/

select season, teams.name, sum(appearances.goals) as 'totals'
from teamstats
join teams on teams.teamID = teamstats.teamID
join appearances on teamstats.gameID = appearances.gameID
where season = 2020
group by teams.name
order by totals desc LIMIT 10;