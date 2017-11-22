#!/bin/bash

az storage account create \
  --name $PROXY_APP_STORAGE \
  --location $REGION \
  --resource-group $RESOURCE_GROUP \
  --sku Standard_LRS

az functionapp create \
  --name $PROXY_APP_NAME \
  --storage-account $PROXY_APP_STORAGE \
  --consumption-plan-location $REGION \
  --resource-group $RESOURCE_GROUP

az functionapp deployment source config \
  --name $PROXY_APP_NAME \
  --repo-url https://github.com/developmentseed/go-functions \
  --branch master \
  --resource-group $RESOURCE_GROUP
