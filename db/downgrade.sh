#!/bin/bash

az postgres server update \
   --resource-group $RESOURCE_GROUP \
   --name $DB_SERVER_NAME  \
   --compute-units 50
