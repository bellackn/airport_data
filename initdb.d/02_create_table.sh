#!/bin/sh
set -e

psql -v ON_ERROR_STOP=1 --dbname paxlife --username admin <<-EOSQL
    CREATE TABLE airports (
        id              INT PRIMARY KEY,
        ident           VARCHAR(7),
        type            VARCHAR(20),
        name            TEXT,
        lat             FLOAT8,
        lon             FLOAT8,
        elevation       INT,
        continent       CHAR(2),
        iso_country     CHAR(2),
        iso_region      VARCHAR(7),
        municipality    TEXT,
        scheduled_svc   VARCHAR(3),
        gps_code        VARCHAR(4),
        iata_code       CHAR(3),
        local_code      VARCHAR(7),
        home_link       TEXT,
        wikipedia_link  TEXT,
        keywords        TEXT
    );
    \COPY airports FROM '/docker-entrypoint-initdb.d/airports.csv' DELIMITER ',' CSV HEADER ENCODING 'utf-8';
EOSQL