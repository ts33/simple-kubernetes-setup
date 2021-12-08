#!/bin/sh

# we do a preliminary check here on the key env variables
if [[ -z "${APP_DB_PASSWORD}" ]]; then
  echo "APP_DB_PASSWORD is undefined"
  exit 1
fi

if [[ -z "${APP_DB_HOST}" ]]; then
  echo "APP_DB_HOST is undefined"
  exit 1
fi

psql "postgresql://postgres:${APP_DB_PASSWORD}@${APP_DB_HOST}:5432/postgres" -f ./seed-db-schema.sql
psql "postgresql://postgres:${APP_DB_PASSWORD}@${APP_DB_HOST}:5432/postgres" -f ./seed-db-data.sql
