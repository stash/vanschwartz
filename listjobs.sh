#!/bin/bash
PGDATABASE=vanpm
psql-8.2 -c 'select jobid,funcid,coalesce,run_after,grabbed_until from job'
