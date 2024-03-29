#!/bin/bash

# ALREADY DONE: az login --username $AZURE_USER --password $AZURE_PASS # --allow-no-subscriptions # Support access tenants without subscriptions. Uncommon but useful to run tenant level commands, such as az ad.

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

export ELASTIC_SEARCH_HOST=$ES_NAME".northeurope.cloudapp.azure.com:9200"

# Remote database
export DB_SERVER_NAME="$DB_SERVER_NAME"  # we need it in 2 places!
export DJANGO_DB_HOST="$DB_SERVER_NAME.postgres.database.azure.com"
export DJANGO_DB_PORT="5432"
export DJANGO_DB_NAME="postgres"
export DJANGO_DB_USER="$dbAdministratorLogin@$DB_SERVER_NAME"
export DJANGO_DB_PASS="$dbAdministratorLoginPassword"

# Databank
export FDRS_CREDENTIAL="$FDRS_CREDENTIAL"

# Azure file storage connection
# ALREADY DONE: CONNECTION="$(az storage account show-connection-string --name $STORAGE_NAME --resource-group $RESOURCE_GROUP --output tsv)"
# ALREADY DONE: export AZURE_STORAGE_CONNECTION_STRING=$CONNECTION

