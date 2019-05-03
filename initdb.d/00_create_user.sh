#!/bin/sh
set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL
    DO
    \$body\$
    BEGIN
        IF NOT EXISTS (SELECT FROM pg_catalog.pg_user WHERE usename = 'admin') THEN
            CREATE ROLE admin LOGIN CREATEDB CREATEROLE PASSWORD '$DB_PASSWORD';
        END IF;
    END
    \$body\$;
EOSQL