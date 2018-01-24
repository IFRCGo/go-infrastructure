#!/bin/bash

API_IP=$(az network public-ip show -g $RESOURCE_GROUP -n $API_IP_NAME --query "{ address: ipAddress }" | jq -r '.address')
LOCAL_IP=$(dig +short myip.opendns.com @resolver1.opendns.com)

az postgres server create \
   --resource-group $RESOURCE_GROUP \
   --name $DB_SERVER_NAME  \
   --location $REGION \
   --admin-user $dbAdministratorLogin \
   --admin-password $dbAdministratorLoginPassword \
   --storage-size 51200 \
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

# Create metric notification rules
DB_APP_ID=$(az resource show -g $RESOURCE_GROUP -n $DB_SERVER_NAME --resource-type "Microsoft.DBforPostgreSQL/servers" --query id --output tsv)

az monitor alert create \
  --name CPUUsage \
  --resource-group $RESOURCE_GROUP \
  --target $DB_APP_ID \
  --condition "cpu_percent > 75 avg 5m" \
  --description "Emails administrators when CPU usage exceeds 75% average for 5 minutes" \
  --email-service-owners \
  --action email derek@developmentseed.org

az monitor alert create \
  --name ComputeUsage \
  --resource-group $RESOURCE_GROUP \
  --target $DB_APP_ID \
  --condition "compute_limit > 75 avg 5m" \
  --description "Emails administrators when compute limit exceeds 75% average for 5 minutes" \
  --email-service-owners \
  --action email derek@developmentseed.org

az monitor alert create \
  --name IOConsumption \
  --resource-group $RESOURCE_GROUP \
  --target $DB_APP_ID \
  --condition "io_consumption_percent > 75 avg 5m" \
  --description "Emails administrators when IO consumption exceeds 75% average for 5 minutes" \
  --email-service-owners \
  --action email derek@developmentseed.org
