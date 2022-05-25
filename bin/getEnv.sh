=================================================================== STAGING
#!/bin/bash

. getCredentials.sh  # get z_account's AZURE_USER, AZURE_PASS

export KEY_CONTAINER="dsgoapikey"
export STORAGE_NAME="dsgofilestorage"
export RESOURCE_GROUP="GOLAB"
export ENV_FILE="envSt"

CONNECTION=\
"$(az storage account show-connection-string --name $STORAGE_NAME --resource-group $RESOURCE_GROUP --output tsv)"
export AZURE_STORAGE_CONNECTION_STRING=$CONNECTION  # needed for blob download

mkdir -p .tmp

az login --username $AZURE_USER --password $AZURE_PASS
az storage blob download \
  --container-name $KEY_CONTAINER \
  --name $ENV_FILE \
  --file .tmp/.env

# echo "*** Local cp env file instead of 'az storage blob download'... ***"
# cat ../.env > .tmp/.env
=================================================================== PROD
#!/bin/bash

. getCredentials.sh  # get z_account's AZURE_USER, AZURE_PASS

export KEY_CONTAINER="dsgoapikey"
export STORAGE_NAME="prddsgofilestorage"
export RESOURCE_GROUP="IFRCGO-Trial1"
export ENV_FILE="envPr"

CONNECTION=\
"$(az storage account show-connection-string --name $STORAGE_NAME --resource-group $RESOURCE_GROUP --output tsv)"
export AZURE_STORAGE_CONNECTION_STRING=$CONNECTION  # needed for blob download

mkdir -p .tmp

az login --username $AZURE_USER --password $AZURE_PASS
az storage blob download \
  --container-name $KEY_CONTAINER \
  --name $ENV_FILE \
  --file .tmp/.env

# echo "*** Local cp env file instead of 'az storage blob download'... ***"
# cat ../.env > .tmp/.env
