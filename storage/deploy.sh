#!/bin/bash

echo "Creating storage account"
az storage account create \
  --name $STORAGE_NAME \
  --location $REGION \
  --resource-group $RESOURCE_GROUP \
  --tags 'ds-project=ifrcgo-infrastructure' \
  --sku Standard_LRS

# Azure file storage connection
CONNECTION="$(az storage account show-connection-string --name $STORAGE_NAME --resource-group $RESOURCE_GROUP --output tsv)"
export AZURE_STORAGE_CONNECTION_STRING=$CONNECTION
