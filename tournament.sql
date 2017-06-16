-- Table definitions for the tournament project.
--
-- Put your SQL 'create table' statements in this file; also 'create view'
-- statements if you choose to use it.
--
-- You can write comments in this file by starting them with two dashes, like
-- these lines here.


DROP DATABASE IF EXISTS tournament;

-- 1. Create database "tournament" and connect to it
CREATE DATABASE tournament;
\c tournament


CREATE TABLE players (
  id SERIAL PRIMARY KEY,
  name TEXT
);

CREATE TABLE matches (
  id SERIAL PRIMARY KEY,
  winner INTEGER REFERENCES players(id),
  loser INTEGER REFERENCES players(id)
);


--Create view for total wins of each player
CREATE VIEW v_wins AS (
  SELECT players.id, COUNT(matches.winner) AS wins
  FROM players JOIN
    matches ON players.id = matches.winner
  GROUP BY players.id
);

-- Create view to for total matches by each player
CREATE VIEW v_matches AS (
  SELECT players.id, COUNT(matches.id) AS total_matches
  FROM matches JOIN players
    ON players.id = matches.winner
    OR players.id = matches.loser
  GROUP BY players.id
);

-- Create view for standings of each player
CREATE VIEW v_standings AS (
  SELECT players.id, players.name, v_wins.wins, v_matches.total_matches
  FROM players LEFT JOIN v_wins
    ON v_wins.id = players.id
    LEFT JOIN v_matches
    ON players.id = v_matches.id
  ORDER BY v_wins.wins DESC
);
