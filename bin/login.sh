#!/bin/bash

az login --username $AZURE_USER --password $AZURE_PASS

# Resource group and region
export RESOURCE_GROUP="GOLAB"
export REGION="northeurope"

# Storage config
export STORAGE_NAME="dsgofilestorage"
export KEY_CONTAINER="dsgoapikey"

CONNECTION="$(az storage account show-connection-string --name $STORAGE_NAME --resource-group $RESOURCE_GROUP --output tsv)"

export AZURE_STORAGE_CONNECTION_STRING=$CONNECTION
