#!/bin/sh
set -e

psql -v ON_ERROR_STOP=1 --dbname template1 --username admin <<-EOSQL
    CREATE DATABASE paxlife OWNER admin;
    COMMENT ON DATABASE paxlife IS 'demo database for coding challenge';
EOSQL
