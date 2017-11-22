#!/bin/bash

az login --username $AZURE_USER --password $AZURE_PASS

# Resource group and region
export RESOURCE_GROUP="GOLAB"
export REGION="northeurope"

# Storage config
export STORAGE_NAME="dsgofilestorage"
export KEY_CONTAINER="dsgoapikey"

# DB config
export DB_SERVER_NAME="dsgodb20171121"
export DJANGO_DB_HOST="$DB_SERVER_NAME.postgres.database.azure.com"
export DJANGO_DB_PORT="5432"
export DJANGO_DB_NAME="postgres"
export DJANGO_DB_USER="$dbAdministratorLogin@$DB_SERVER_NAME"
export DJANGO_DB_PASS="$dbAdministratorLoginPassword"

# Azure file storage connection
CONNECTION="$(az storage account show-connection-string --name $STORAGE_NAME --resource-group $RESOURCE_GROUP --output tsv)"
export AZURE_STORAGE_CONNECTION_STRING=$CONNECTION
