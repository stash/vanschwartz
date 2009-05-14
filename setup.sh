#!/bin/bash
set -x
PGDATABASE=vanpm
dropdb-8.2 $PGDATABASE
createdb-8.2 -E UTF-8 -O stash $PGDATABASE
psql-8.2 -f schwartz.sql
