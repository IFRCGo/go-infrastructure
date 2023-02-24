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

ssh -i .tmp/key -o StrictHostKeychecking=no $API_ADMIN@$IP /bin/bash << EOF
  docker stop \$(docker ps -q)
  docker rm \$(docker ps -a -q)
# docker run -d -p 9200:9200 -e "discovery.type=single-node" docker.elastic.co/elasticsearch/elasticsearch-oss:6.8.21 - for django-haystack:
  docker run -d -p 9200:9200 -e "discovery.type=single-node" docker.elastic.co/elasticsearch/elasticsearch:7.0.0
EOF
# if you upgrade elasticsearch version, a manage.py create_index is also needed, and keep synched with go-api pyproject.toml

rm .tmp/key
