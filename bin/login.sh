#!/bin/bash

az login --username $AZURE_USER --password $AZURE_PASS

# Resource group and region
export REGION="northeurope"

# Proxy apps
export PROXY_APP_NAME=$PREFIX"dsgoproxyapp"
export PROXY_APP_STORAGE=$PREFIX"dsgoproxystorage"

# Storage config
export STORAGE_NAME=$PREFIX"dsgofilestorage"
export KEY_CONTAINER="dsgoapikey"

# Shared VM config
export VNET_NAME=$PREFIX"dsgoVnet"
export GO_NSG=$PREFIX"dsgoNSG"

# CDN
export CDN_NAME=$PREFIX"dsgoCdn"
export CDN_API_ENDPOINT_NAME=$PREFIX"dsgocdnapi"

# API VM
export API_IP_NAME=$PREFIX"dsgoapiPublicIP"
export API_DNS=$PREFIX"dsgoapi"
export API_SUBNET=$PREFIX"dsgoapisubnet"
export API_NIC=$PREFIX"dsgoapiPublicVMNIC"
export API_NAME=$PREFIX"dsgoapi"

# ES VM
export ES_IP_NAME=$PREFIX"dsgoesPublicIP"
export ES_DNS=$PREFIX"dsgoes"
export ES_SUBNET=$PREFIX"dsgoelasticsubnet"
export ES_NIC=$PREFIX"dsgoesPublicVMNIC"
export ES_NAME=$PREFIX"dsgoes"

export ES_HOST=$ES_NAME".northeurope.cloudapp.azure.com:9200"

# DB config
if [ $PRODUCTION == 1 ]; then
  # If you change this, do not forget to set the firewall rules for the new db:
  export DB_SERVER_NAME=$PREFIX"dsgodb20211030" # Obsolete psql9.6:dsgodb20190208
else
  export DB_SERVER_NAME=$PREFIX"dsgodb20211022" # Obsolete psql9.6:dsgodb20171121
fi
export DJANGO_DB_HOST="$DB_SERVER_NAME.postgres.database.azure.com"
export DJANGO_DB_PORT="5432"
export DJANGO_DB_NAME="postgres"
export DJANGO_DB_USER="$dbAdministratorLogin@$DB_SERVER_NAME"
export DJANGO_DB_PASS="$dbAdministratorLoginPassword"

# Azure file storage connection
CONNECTION="$(az storage account show-connection-string --name $STORAGE_NAME --resource-group $RESOURCE_GROUP --output tsv)"
export AZURE_STORAGE_CONNECTION_STRING=$CONNECTION
