#!/bin/bash

CONNECTION="$(az storage account show-connection-string --name $STORAGE_NAME --resource-group $RESOURCE_GROUP --output tsv)"
export AZURE_STORAGE_CONNECTION_STRING=$CONNECTION

mkdir -p .tmp
az storage blob download \
  --container-name $KEY_CONTAINER \
  --name api \
  --file .tmp/key

chmod 600 .tmp/key

IP="$(az vm list-ip-addresses --resource-group $RESOURCE_GROUP --name $ES_NAME --query [0].virtualMachine.network.publicIpAddresses[0].ipAddress -o tsv)"

ssh -i .tmp/key -o StrictHostKeychecking=no $API_ADMIN@$IP docker run -d -p 9200:9200 -e "discovery.type=single-node" docker.elastic.co/elasticsearch/elasticsearch-oss:6.0.0

rm .tmp/key
