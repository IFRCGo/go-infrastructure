#!/bin/bash

echo Creating storage account
az storage account create \
  --name dsgostorage \
  --location $REGION \
  --resource-group $RESOURCE_GROUP \
  --tags 'ds-project=ifrcgo-infrastructure' \
  --sku Standard_LRS

CONNECTION="$(az storage account show-connection-string --name dsgostorage --resource-group $RESOURCE_GROUP --output tsv)"
export AZURE_STORAGE_CONNECTION_STRING=$CONNECTION

az storage container create --name dsgoapikey
export KEY_CONTAINER=dsgoapikey
