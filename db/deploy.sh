#!/bin/bash

az postgres server create \
   --resource-group $RESOURCE_GROUP \
   --name $DB_SERVER_NAME  \
   --location $REGION \
   --admin-user $dbAdministratorLogin \
   --admin-password $dbAdministratorLoginPassword \
   --performance-tier Basic \
   --compute-units 50 \
   --version 9.6

az postgres server firewall-rule create \
  --resource-group $RESOURCE_GROUP \
  --server $DB_SERVER_NAME \
  --name AllowAllIps \
  --start-ip-address 0.0.0.0 \
  --end-ip-address 255.255.255.255
