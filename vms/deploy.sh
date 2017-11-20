#!/bin/bash

CONNECTION="$(az storage account show-connection-string --name dsgostorage --resource-group $RESOURCE_GROUP --output tsv)"
export AZURE_STORAGE_CONNECTION_STRING=$CONNECTION

mkdir -p .tmp

az storage blob download \
  --container-name dsgoapikey \
  --name api.pub \
  --file .tmp/key

NSG_SUFFIX=NSG
NSG_NAME=$API_APP_NAME$NSG_SUFFIX
az vm create \
  --ssh-key-value @.tmp/key \
  --authentication-type ssh \
  --admin-username $API_ADMIN \
  --resource-group $RESOURCE_GROUP \
  --name $API_APP_NAME \
  --nsg $NSG_NAME \
  --location $REGION \
  --image UbuntuLTS \
  --storage-sku Standard_LRS \
  --tags 'ds-project=ifrcgo-infrastructure'

rm .tmp/key

# set the docker extension
az vm extension set \
  --name DockerExtension \
  --publisher Microsoft.Azure.Extensions \
  --vm-name $API_APP_NAME \
  --resource-group $RESOURCE_GROUP \
  --version 1.1

# open port 80
az network nsg rule create \
  --resource-group $RESOURCE_GROUP \
  --nsg-name $NSG_NAME \
  --name HTTP80 \
  --protocop tcp \
  --priority 100 \
  --destination-port-range 80
