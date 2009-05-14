#!/bin/bash
set -x

dropdb-8.2 vanpm
createdb-8.2 -E UTF-8 -O stash vanpm
psql-8.2 -f schwartz.sql
