#!/bin/bash

echo "Creating storage account"
az storage account create \
  --name $STORAGE_NAME \
  --location $REGION \
  --resource-group $RESOURCE_GROUP \
  --tags 'ds-project=ifrcgo-infrastructure' \
  --sku Standard_LRS

echo "Creating key storage container"
az storage container create \
  --name $KEY_CONTAINER \
  --public-access off

echo "Creating frontend storage container"
az storage container create \
  --name site \
  --public-access blob

echo "Creating tile storage container"
az storage container create \
  --name tiles \
  --public-access blob
