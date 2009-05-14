#!/bin/bash
PGDATABASE=vanpm
psql-8.2 -c 'select jobid,funcid,funcname,coalesce,run_after,grabbed_until from job natural join funcmap'
