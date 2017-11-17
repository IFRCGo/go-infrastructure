#!/bin/bash

CONNECTION="$(az storage account show-connection-string --name dsgostorage --resource-group $RESOURCE_GROUP --output tsv)"
export AZURE_STORAGE_CONNECTION_STRING=$CONNECTION

mkdir -p .tmp

az storage blob download \
  --container-name dsgoapikey \
  --name api \
  --file .tmp/key

chmod 600 .tmp/key

IP="$(az vm list-ip-addresses --resource-group $RESOURCE_GROUP --name $API_APP_NAME --query [0].virtualMachine.network.publicIpAddresses[0].ipAddress -o tsv)"

echo DJANGO_SECRET_KEY=$DJANGO_SECRET_KEY >> .tmp/env
echo DJANGO_DB_HOST=$DJANGO_DB_HOST >> .tmp/env
echo DJANGO_DB_PORT=$DJANGO_DB_PORT >> .tmp/env
echo DJANGO_DB_NAME=$DJANGO_DB_NAME >> .tmp/env
echo DJANGO_DB_USER=$DJANGO_DB_USER >> .tmp/env
echo DJANGO_DB_PASS=$DJANGO_DB_PASS >> .tmp/env
echo GO_FTPHOST=$GO_FTPHOST >> .tmp/env
echo GO_FTPUSER=$GO_FTPUSER >> .tmp/env
echo GO_FTPPASS=$GO_FTPPASS >> .tmp/env
echo GO_DBPASS=$GO_DBPASS >> .tmp/env

scp -i .tmp/key .tmp/env $API_ADMIN@$IP:.env
ssh -i .tmp/key -o StrictHostKeychecking=no $API_ADMIN@$IP
#docker run -d -p 80:80 --env-file .env -t developmentseed/ifrc-go-api:0.1.2

rm .tmp/env
rm .tmp/key
