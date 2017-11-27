#!/bin/bash

export PGPASSWORD=$DJANGO_DB_PASS
psql \
  -U $DJANGO_DB_USER \
  -h $DJANGO_DB_HOST \
  -d $DJANGO_DB_NAME \
  -p $DJANGO_DB_PORT \
  -f db/postgis.sql
