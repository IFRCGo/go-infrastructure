#!/bin/bash

API_IP=$(az network public-ip show -g $RESOURCE_GROUP -n $API_IP_NAME --query "{ address: ipAddress }" | jq -r '.address')
LOCAL_IP=$(ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1')

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
  --name AllowAPI \
  --start-ip-address $API_IP \
  --end-ip-address $API_IP

az postgres server firewall-rule create \
  --resource-group $RESOURCE_GROUP \
  --server $DB_SERVER_NAME \
  --name AllowLocalMachine \
  --start-ip-address $LOCAL_IP \
  --end-ip-address $LOCAL_IP
